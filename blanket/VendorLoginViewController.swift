//
//  VendorLoginViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-12.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit
import Just
import KeychainSwift

protocol VendorLoginDelegate {
    func vendorDidLogin()
}

class VendorLoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var vendorLoginDelegate: VendorLoginDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        let postData = ["username": username,
                         "password": password]
        
        let authResponse = Just.post("http://10.1.0.211:8888/api-token-auth/",
                                      data: postData)
        
        if authResponse.ok {
            let responseData = authResponse.json as! NSDictionary
            
            let sharedUser = SharedUser.sharedUser
            
            sharedUser.username = username
            sharedUser.password = password
            sharedUser.company = responseData.value(forKey: "company") as! String
            sharedUser.firstName = responseData.value(forKey: "first_name") as! String
            sharedUser.lastName = responseData.value(forKey: "last_name") as! String
            sharedUser.profileImage = responseData.value(forKey: "image") as! String
            sharedUser.jwtToken = responseData.value(forKey: "token") as! String
            
            sharedUser.syncAuthData()
            
            vendorLoginDelegate.vendorDidLogin()
        } else {
            print(authResponse.text!)
        }
    }
}
