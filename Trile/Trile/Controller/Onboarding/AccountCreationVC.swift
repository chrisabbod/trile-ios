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
        
    let NOTIFICATION_VALUE = "showAdditionalInfoVC"
    
    let db = Firestore.firestore()
    let alert = AlertPresenterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Button Functions
    
    @IBAction func createAccountButton(_ sender: Any) {
//        createNewUser()
        showAdditionalInfoVC()
    }
    
    func createNewUser() {
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var errorMessage: String = ""
        
        if firstName.isEmpty {
            errorMessage = "A first name must be provided"
            self.alert.errorMessageAlertDialog(fromViewController: self, withMessage: errorMessage)
        } else if lastName.isEmpty {
            errorMessage = "A last name must be provided"
            self.alert.errorMessageAlertDialog(fromViewController: self, withMessage: errorMessage)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                let uid: String = Auth.auth().currentUser!.uid
                
                if error != nil {
                    if let errorMessage = error?.localizedDescription {
                        self.alert.errorMessageAlertDialog(fromViewController: self, withMessage: errorMessage)
                    }
                    print("Unable to authenticate user \(error.debugDescription)")
                } else {
                                        
                    self.db.collection("users").document(uid).setData([
                        "first_name":firstName,
                        "last_name":lastName,
                        "email": email,
                        "uid": result!.user.uid])
                    
                    self.showAdditionalInfoVC()
                }
            }
        }
    }
    
    func showAdditionalInfoVC() {
        self.dismiss(animated: true, completion: nil);

        //Calls Notification Function in LoginVC to go to AdditionalInfoVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
    }
}
