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
    
    let MIN_LENGTH = 6
    
    let newUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Button Functions
    
    @IBAction func continueButton(_ sender: Any) {
        getUserInformation { (success) in
            if success {
                self.performSegue(withIdentifier: "showAdditionalInfoVC", sender: self)
            }
        }
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AdditionalInfoVC
        destinationVC.userData = newUser
    }
    
    func getUserInformation(completion: @escaping ((_ success: Bool) -> Void)) {
                
        newUser.firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        newUser.lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        newUser.email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        newUser.password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newUser.firstName.isEmpty {
            print("No first name entered")
            completion(false)
        } else if newUser.lastName.isEmpty {
            print("No last name entered")
            completion(false)
        } else if newUser.email.isEmpty {
            print("No email entered")
            completion(false)
        } else if newUser.password.isEmpty || newUser.password.count < MIN_LENGTH {
            print("Invalid password entered")
            completion(false)
        } else {
            completion(true)
        }
    }
    
}
