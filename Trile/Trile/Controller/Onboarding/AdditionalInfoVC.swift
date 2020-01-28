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

    let statePickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldInputs()
        setDelegates()
        setPickerViewBackgroundColor()
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
        saveUserData()
        
        self.dismiss(animated: true, completion: nil)
        
        //Calls Notification Function in LoginVC to show alert dialog
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
    }
    
    //MARK: Save User Data
    
    func saveUserData() {
        var userDataArray = [String: Any]()
        var soloPractitioner: Bool
        
        if firmSegmentedControl.selectedSegmentIndex == 0 {
            soloPractitioner = false
            
            if let firmName = firmNameTextField.text {
                userDataArray["firm_name"] = firmName
            }
            
            if let taxpayerID = taxpayerIDTextField.text {
                userDataArray["taxpayer_id"] = taxpayerID
            }
        } else {
            soloPractitioner = true
        }
        
        userDataArray["solo_practitioner"] = soloPractitioner
        
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

extension AdditionalInfoVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Set Text Field Inputs
    
    func setTextFieldInputs() {
        stateTextField.inputView = statePickerView
    }
    
    //MARK: Set Delegates
    
    func setDelegates() {
        firmNameTextField.delegate = self
        taxpayerIDTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        
        statePickerView.delegate = self
    }
    
    //MARK: Text Restriction Function
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firmNameTextField {
            return TextRestrictionManager.restrictTextLength(by: 40, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == addressTextField || textField == cityTextField {
            return TextRestrictionManager.restrictTextLength(by: 30, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == taxpayerIDTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 9, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == zipTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 5, textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return true
    }
    
    //MARK: - Picker View Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerListManager.statesList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerListManager.statesList[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = PickerListManager.statesList[row]
    }
    
    //MARK: UI Beautification Functions
    
    func setPickerViewBackgroundColor() {
        statePickerView.backgroundColor  = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
    }
}
