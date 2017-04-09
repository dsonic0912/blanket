//
//  ClientLoginViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-20.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit
import Just

protocol ClientLoginDelegate {
    func clientDidLogin()
}

class ClientLoginViewController: UIViewController {
    
    var clientLoginDelegate: ClientLoginDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
