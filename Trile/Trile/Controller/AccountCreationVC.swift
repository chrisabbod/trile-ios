//
//  AccountCreationVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/27/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountCreationVC: UIViewController {

    var email = ""
    var password = ""
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if let userEmail = emailText.text {
            email = userEmail
        }
        
        if let userPassword = passwordText.text {
            password = userPassword
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Email: \(self.email)")
            print("Password: \(self.password)")
        }
    }
    
}
