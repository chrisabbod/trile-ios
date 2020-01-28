//
//  ForgotPasswordVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/27/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    let SUCCESS_MESSAGE_TITLE = "Success!"
    let ERROR_MESSAGE_TITLE = "Problem Sending Email"
    
    let alert = AlertPresenterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        if let userEmail = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: userEmail) { (error) in
                if (error != nil) {
                    
                    let title = self.ERROR_MESSAGE_TITLE

                    if let message = error?.localizedDescription {
                        self.alert.messageAlertDialog(fromViewController: self, withTitle: title, withMessage: message)
                    }
                    print("Unable to send email: \(error.debugDescription)")
                } else {
                    let message = "A recovery email has been sent to \(userEmail)"
                    self.alert.messageAlertDialog(fromViewController: self, withTitle: self.SUCCESS_MESSAGE_TITLE, withMessage: message)
                }
            }
        }
        
    }
}
