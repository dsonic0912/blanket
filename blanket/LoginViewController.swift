//
//  LoginViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-12.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var vendorLoginDelegate: BaseViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vendorLoginVC = segue.destination as! VendorLoginViewController
        vendorLoginVC.vendorLoginDelegate = vendorLoginDelegate
    }

}
