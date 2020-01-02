//
//  ClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/1/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class ClientDetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        
        self.navigationItem.rightBarButtonItem = signOutButton
        
        //        circularImage.layer.masksToBounds = true
        //        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
    }
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
    }
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
}
