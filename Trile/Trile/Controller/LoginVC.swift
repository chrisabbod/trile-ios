//
//  LoginVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/29/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    let LOGIN_SEGUE = "showClientTableVC"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func LoginButton(_ sender: Any) {
        loginAction()
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func loginAction() {
        let loginManager = FirebaseAuthManager()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            
            if (success) {
                message = "User was sucessfully logged in."
                self.performSegue(withIdentifier: self.LOGIN_SEGUE, sender: self)
            } else {
                message = "There was an error."
            }
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.display(alertController: alertController)
        }
    }
    //MARK: - Test Functions
    
    @IBAction func testLogin(_ sender: Any) {
        emailTextField.text = "chrisabbod@gmail.com"
        passwordTextField.text = "Seraphim88"
        loginAction()
    }
    
}
