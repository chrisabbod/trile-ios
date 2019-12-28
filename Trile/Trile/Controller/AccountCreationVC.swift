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

    var fullName = ""
    var email = ""
    var password = ""
    var phoneNumber = ""
    

    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if let userFullName = fullNameText.text {
            fullName = userFullName
        }
        
        if let userEmail = emailText.text {
            email = userEmail
        }
        
        if let userPassword = passwordText.text {
            password = userPassword
        }
        
        if let userPhoneNumber = phoneNumberText.text {
            phoneNumber = userPhoneNumber
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Full Name: \(self.fullName)")
            print("Email: \(self.email)")
            print("Password: \(self.password)")
            print("Phone Number: \(self.phoneNumber)")
        }
    }
    
}
