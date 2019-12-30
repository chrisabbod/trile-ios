//
//  AccountCreationVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/27/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountCreationVC: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        // Create cleaned versions of the data
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            var message: String = ""
            if err != nil {
                message = "Error creating user"
            }
            else {
                
                let db = Firestore.firestore()
                message = "User was successfully created"
                
                db.collection("users").addDocument(data: [
                    "first_name":firstName,
                    "last_name":lastName,
                    "email": email,
                    "uid": result!.user.uid ]
                ) { (error) in
                    if error != nil {
                        message = "There was a problem storing data"
                    }
                }
                
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
                
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
