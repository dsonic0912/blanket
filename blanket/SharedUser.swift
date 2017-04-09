//
//  SharedUser.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-20.
//  Copyright © 2017 Procurify. All rights reserved.
//

import Foundation
import KeychainSwift

class SharedUser {
    static let sharedUser = SharedUser()
    
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var profileImage: String
    var company: String
    var jwtToken: String
    
    init() {
        let keychain = KeychainSwift()
        
        if let storedKeychain = keychain.getData("auth") {
            let keyData = NSKeyedUnarchiver.unarchiveObject(with: storedKeychain) as! NSDictionary
            username = keyData.value(forKey: "username") as! String
            password = keyData.value(forKey: "password") as! String
            firstName = keyData.value(forKey: "firstName") as! String
            lastName = keyData.value(forKey: "lastName") as! String
            profileImage = keyData.value(forKey: "profileImage") as! String
            company = keyData.value(forKey: "company") as! String
            jwtToken = keyData.value(forKey: "jwtToken") as! String
        } else {
            username = ""
            password = ""
            firstName = ""
            lastName = ""
            profileImage = ""
            company = ""
            jwtToken = ""
        }
    }
    
    func syncAuthData() {
        let authData = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "profileImage": profileImage,
            "company": company,
            "jwtToken": jwtToken
        ]
        
        let keyData = NSKeyedArchiver.archivedData(withRootObject: authData) as Data
        let keychain = KeychainSwift()
        keychain.set(keyData, forKey: "auth")
    }
    
    func getUserPhotoImageUrl() -> String {
        return "https://commondatastorage.googleapis.com/cdn.procurify.com/\(self.profileImage)"
    }
}
