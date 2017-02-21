//
//  BaseViewController.swift
//  blanket
//
//  Created by Ta Chien Tung on 2017-02-12.
//  Copyright © 2017 Procurify. All rights reserved.
//

import UIKit
import Just
import KeychainSwift

class BaseViewController: UIViewController, VendorLoginDelegate {
    private var loginNavVC: LoginNavController! = nil
    private var tabBarVC: TabBarController! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        websocket.delegate = self
        websocket.connect()*/
        cleanUpViews()
        
        let keychain = KeychainSwift()
        
        if let _ = keychain.getData("auth") {
            swapToTabBarView()
        } else {
            swapToLoginView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cleanUpViews()
        swapToLoginView()
    }
    
    private func cleanUpViews() {
        if loginNavVC != nil {
            loginNavVC.willMove(toParentViewController: self)
            loginNavVC.view.removeFromSuperview()
            loginNavVC.removeFromParentViewController()
        }
        
        if tabBarVC != nil {
            tabBarVC.willMove(toParentViewController: self)
            tabBarVC.view.removeFromSuperview()
            tabBarVC.removeFromParentViewController()
        }
    }

    private func swapToLoginView() {
        loginNavVC = storyboard?.instantiateViewController(withIdentifier: "LoginNavVC") as! LoginNavController
        loginNavVC.view.frame = view.frame
        addChildViewController(loginNavVC)
        view.insertSubview(loginNavVC.view, at: 0)
        
        let loginVC = loginNavVC.viewControllers[0] as! LoginViewController
        loginVC.vendorLoginDelegate = self
        
        loginNavVC.didMove(toParentViewController: self)
    }
    
    private func swapToTabBarView() {
        tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarController
        tabBarVC.view.frame = view.frame
        addChildViewController(tabBarVC)
        view.insertSubview(tabBarVC.view, at: 0)
        
        tabBarVC.didMove(toParentViewController: self)
    }
    
    func vendorDidLogin() {
        cleanUpViews()
        swapToTabBarView()
    }
}
