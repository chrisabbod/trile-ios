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
    
    let NOTIFICATION_VALUE = "accountCreatedDialog"
    
    let db = Firestore.firestore()
    let dbm = FirebaseFirestoreManager()
    let alert = AlertPresenterManager()
    
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
    
    @IBAction func saveAndReturnButton(_ sender: Any) {
        saveCaseData()
        
        self.dismiss(animated: true, completion: nil)
        
        //Calls Notification Function in LoginVC to show alert dialog
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
    }
    
    func saveCaseData() {
        var userDataArray = [String: Any]()
        
        if firmSegmentedControl.selectedSegmentIndex == 0 {
            if let firmName = firmNameTextField.text {
                userDataArray["firm_name"] = firmName
            }
            
            if let taxpayerID = taxpayerIDTextField.text {
                userDataArray["taxpayer_id"] = taxpayerID
            }
        }
        
        if let address = addressTextField.text {
            userDataArray["address"] = address
        }
        
        if let city = cityTextField.text {
            userDataArray["city"] = city
        }
        
        if let state = stateTextField.text {
            userDataArray["state"] = state
        }
        
        if let zip = zipTextField.text {
            userDataArray["zip"] = zip
        }
        
        dbm.addUserDataToDatabase(userDataArray)
    }
}
