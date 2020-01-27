//
//  LoginVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/29/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let LOGIN_SEGUE = "showClientTableVC"
    let ACCOUNT_CREATION_SEGUE = "showAccountCreationVC"
    let ADDITIONAL_INFO_NOTIFICATION = "showAdditionalInfoVC"
    let ADDITIONAL_INFO_IDENTIFIER = "additionalInfoVC"
    let ACCOUNT_CREATED_NOTIFICATION = "accountCreatedDialog"
    
    let alert = AlertPresenterManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display AdditionalInfoVC when a new user is created in AccountCreationVC
        NotificationCenter.default.addObserver(self, selector: #selector(showAdditionalInfoVC), name: NSNotification.Name(rawValue: ADDITIONAL_INFO_NOTIFICATION), object: nil)
        
        //Display a dialog alerting the user that their account was created after returning from AdditionalInfoVC
        NotificationCenter.default.addObserver(self, selector: #selector(showAccountCreatedDialog), name: NSNotification.Name(rawValue: ACCOUNT_CREATED_NOTIFICATION), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearTextFields()
    }
    
    //MARK: Button Functions
    
    @IBAction func LoginButton(_ sender: Any) {
        loginAction()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: ACCOUNT_CREATION_SEGUE, sender: self)
    }
    
    //MARK: Clear Text Fields
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: Login Function
    
    func loginAction() {
        let loginManager = FirebaseAuthManager()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var title: String = ""
            var message: String = ""
            
            if (success) {
                message = "User was sucessfully logged in."
                self.performSegue(withIdentifier: self.LOGIN_SEGUE, sender: self)
            } else {
                title = "Login Failure"
                message = "Unable to log in"
                self.alert.messageAlertDialog(fromViewController: self, withTitle: title, withMessage: message)
            }
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        }
    }
    
    //MARK: Segue Functions
    
    @objc
    func showAdditionalInfoVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: ADDITIONAL_INFO_IDENTIFIER) as! AdditionalInfoVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc
    func showAccountCreatedDialog() {
        let title = "Account Update"
        let message = "Account successfully created!"
        alert.messageAlertDialog(fromViewController: self, withTitle: title, withMessage: message)
    }
    
    //MARK: Test Functions
    
    @IBAction func testLogin(_ sender: Any) {
        emailTextField.text = "chrisabbod@gmail.com"
        passwordTextField.text = "Seraphim88"
    }
    
}
