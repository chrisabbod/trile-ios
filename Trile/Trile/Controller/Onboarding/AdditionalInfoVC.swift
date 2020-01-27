//
//  AdditionalInfoVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/26/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AdditionalInfoVC: UIViewController {

    @IBOutlet weak var firmSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firmNameTextField: UITextField!
    @IBOutlet weak var taxpayerIDTextField: UITextField!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    let db = Firestore.firestore()
    let dbm = FirebaseFirestoreManager()
    
    var userData: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func firmSegmentedControl(_ sender: Any) {
        if firmSegmentedControl.selectedSegmentIndex == 0 {
            firmNameTextField.isEnabled = true
            taxpayerIDTextField.isEnabled = true
            print("User has firm")
        } else {
            firmNameTextField.isEnabled = false
            taxpayerIDTextField.isEnabled = false
            print("User is solo practitioner")
        }
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        authenticateUser()
    }
    
    func saveUserData() {
        var userDataArray = [String: Any]()
        
        if let firmName = firmNameTextField.text {
            userDataArray["firm_name"] = firmName
        }
        
//        dbm.add
//
//        if let client = selectedClient, let fileNumber = selectedFileNumber {
//            dbm.addCaseDataToDatabase(client, fileNumber, caseDataArray)
//        }
    }
    
    func authenticateUser() {
        guard let firstName = userData?.firstName else { return print("First name not found")}
        guard let lastName = userData?.lastName else { return print("Last name not found")}
        guard let email = userData?.email else { return print("Email not found")}
        guard let password = userData?.password else { return print("Password not found")}

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            let uid: String = Auth.auth().currentUser!.uid

            if error != nil {
                print("Unable to authenticate user")
                print(error.debugDescription as String)
            }
            else {
                print("User authenticated")
                self.db.collection("users").document(uid).setData([
                    "first_name":firstName,
                    "last_name":lastName,
                    "email": email,
                    "uid": result!.user.uid])

                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")

        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
    }
}

//@IBAction func createAccountButton(_ sender: Any) {
//
//    // Create cleaned versions of the data
//    let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//    let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//        let uid: String = Auth.auth().currentUser!.uid
//        //var message: String = ""
//
//        if err != nil {
//            //message = "Error creating user"
//        }
//        else {
//
//            let db = Firestore.firestore()
//            //message = "User was successfully created"
//
//            db.collection("users").document(uid).setData([
//                "first_name":firstName,
//                "last_name":lastName,
//                "email": email,
//                "uid": result!.user.uid])
//
//            self.transitionToHome()
//        }
//    }
//}
//
//func transitionToHome() {
//    let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
//
//    view.window?.rootViewController = loginVC
//    view.window?.makeKeyAndVisible()
//}
