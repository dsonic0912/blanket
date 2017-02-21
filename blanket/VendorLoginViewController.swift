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
        
        let authResponse = Just.post("https://blanket.localtunnel.me/api-token-auth/",
                                      data: postData)
        
        if authResponse.ok {
            let responseData = authResponse.json as! NSDictionary

            let keyData = NSKeyedArchiver.archivedData(withRootObject: responseData) as Data
            let keychain = KeychainSwift()
            
            keychain.set(keyData, forKey: "auth")
            
            vendorLoginDelegate.vendorDidLogin()
        } else {
            print(authResponse.text!)
        }
    }
}
