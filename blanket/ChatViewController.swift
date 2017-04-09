//
//  ChatViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-20.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit
import SlackTextViewController
import Starscream
import AVFoundation
import Kingfisher

class ChatViewController: SLKTextViewController, WebSocketDelegate {
    
    var websocket: WebSocket!
    var messages: [[String: Any]] = []
    
    private var foregroundNotification: NSObjectProtocol!
    private var backgroundNotification: NSObjectProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let jwtToken = SharedUser.sharedUser.jwtToken
        
        websocket = WebSocket(url: URL(string: "ws://blanket.localtunnel.me/chat/?token=\(jwtToken)")!)
        websocket.delegate = self
        websocket.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        websocket.disconnect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.separatorStyle = .none
        tableView?.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: "MessengerCell")
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 100
        
        foregroundNotification = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: {notification in
            
            if !self.websocket.isConnected {
                self.websocket.connect()
            }
        })
        
        backgroundNotification = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: {notification in
            
            if self.websocket.isConnected {
                self.websocket.disconnect()
            }
        })
    }
}

extension ChatViewController {
    
    override func didPressRightButton(_ sender: Any?) {
        // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
        let sharedUser = SharedUser.sharedUser
        
        let messageData: [String: Any] = [
            "message": self.textView.text,
            "token": sharedUser.jwtToken,
            "sender": sharedUser.username,
            "firstName": sharedUser.firstName,
            "profileImage": sharedUser.getUserPhotoImageUrl()
        ]
        
        do {
            let messageJson = try JSONSerialization.data(withJSONObject: messageData, options: .prettyPrinted)
            let messageText = String(data: messageJson, encoding: .utf8)
            
            websocket.write(string: messageText!)
        } catch {
            print(error.localizedDescription)
        }
        
        self.textView.refreshFirstResponder()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let rowAnimation: UITableViewRowAnimation = self.isInverted ? .bottom : .top
        let scrollPosition: UITableViewScrollPosition = self.isInverted ? .bottom : .top
        
        tableView?.beginUpdates()
        self.messages.insert(messageData, at: 0)
        tableView?.insertRows(at: [indexPath], with: rowAnimation)
        tableView?.endUpdates()
        
        tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        
        // Fixes the cell from blinking (because of the transform, when using translucent cells)
        // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
        tableView?.reloadRows(at: [indexPath], with: .automatic)
        
        super.didPressRightButton(sender)
    }
}

extension ChatViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessengerCell", for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
    
        cell.titleLabel.text = message["sender"] as? String
        cell.bodyLabel.text = message["message"] as? String
        cell.thumbnailView.kf.setImage(with: URL(string: message["profileImage"] as! String)!)
        print(message["profileImage"] as! String)
        
        cell.transform = tableView.transform
        
        return cell
    }
}

extension ChatViewController {
    
    func websocketDidConnect(socket: WebSocket) {
        print("webscoket connected")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("websocket did receive data")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        let messageDict = convertToDictionary(text: text)
        let sender = messageDict?["sender"] as! String
        
        if sender != SharedUser.sharedUser.username {
            self.textView.refreshFirstResponder()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let rowAnimation: UITableViewRowAnimation = self.isInverted ? .bottom : .top
            let scrollPosition: UITableViewScrollPosition = self.isInverted ? .bottom : .top
            
            tableView?.beginUpdates()
            self.messages.insert(messageDict!, at: 0)
            tableView?.insertRows(at: [indexPath], with: rowAnimation)
            tableView?.endUpdates()
            
            tableView?.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
            
            // Fixes the cell from blinking (because of the transform, when using translucent cells)
            // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("did disconnect")
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
