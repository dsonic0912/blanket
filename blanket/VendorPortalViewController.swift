//
//  VendorPortalViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-04-06.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit

class VendorPortalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func openProcurifyButtonPressed(_ sender: UIButton) {
        let url = URL(string: "blanketlink://procurify.com/test")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        let url = URL(string: "blanketlink://procurify.com/test")
        UIApplication.shared.openURL(url!)
    }

}
