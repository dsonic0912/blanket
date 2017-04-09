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
        
        let bgImage = UIImage(named: "nav_bar_bg")!
        navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToVendorSegue" {
            let vendorLoginVC = segue.destination as! VendorLoginViewController
            vendorLoginVC.vendorLoginDelegate = vendorLoginDelegate
        }
        
//        if segue.identifier == "LoginToClientSegue" {
//            let clientLoginVC = segue.destination as! ClientLoginViewController
//        }
    }

}
