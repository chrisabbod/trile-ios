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
    let ACCOUNT_CREATION_SEGUE = "showAccountCreationVC"
    let ADDITIONAL_INFO_NOTIFICATION = "showAdditionalInfoVC"
    let ADDITIONAL_INFO_IDENTIFIER = "additionalInfoVC"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Display AdditionalInfoVC when a new user is created in AccountCreationVC
        NotificationCenter.default.addObserver(self, selector: #selector(showAdditionalInfoVC), name: NSNotification.Name(rawValue: ADDITIONAL_INFO_NOTIFICATION), object: nil)
    }

    //MARK: Button Functions
    
    @IBAction func LoginButton(_ sender: Any) {
        loginAction()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: ACCOUNT_CREATION_SEGUE, sender: self)
    }
    
    //MARK: Login Function
    
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

        }
    }
    
    //MARK: Segue Function
    
    @objc
    func showAdditionalInfoVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: ADDITIONAL_INFO_IDENTIFIER) as! AdditionalInfoVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    //MARK: Test Functions
    
    @IBAction func testLogin(_ sender: Any) {
        emailTextField.text = "chrisabbod@gmail.com"
        passwordTextField.text = "Seraphim88"
    }
    
}
