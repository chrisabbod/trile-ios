//
//  EditUserInfoVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/27/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EditUserInfoVC: UIViewController {
    
    @IBOutlet weak var firmSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firmNameTextField: UITextField!
    @IBOutlet weak var taxpayerIDTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        dbm.readUserDataFromDatabase { (userDataArray, success) in
            if success {
                self.readUserData(userDataArray)
            }
        }
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
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Read User Data
    
    func readUserData(_ userData: [String: Any]) {
        
        if let soloPractitioner: Bool = userData["solo_practitioner"] as? Bool {
            if !soloPractitioner {
                firmSegmentedControl.selectedSegmentIndex = 0
            } else {
                firmSegmentedControl.selectedSegmentIndex = 1
            }
        }
        
        if let firmName = userData["firm_name"] {
            firmNameTextField.text = firmName as? String
        }
        
        if let taxpayerID = userData["taxpayer_id"] {
            taxpayerIDTextField.text = taxpayerID as? String
        }
        
        if let phoneNumber = userData["phone_number"] {
            phoneNumberTextField.text = phoneNumber as? String
        }
        
        if let address = userData["address"] {
            addressTextField.text = address as? String
        }
        
        if let city = userData["city"] {
            cityTextField.text = city as? String
        }
        
        if let state = userData["state"] {
            stateTextField.text = state as? String
        }
        
        if let zip = userData["zip"] {
            zipTextField.text = zip as? String
        }
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
        
        if let phoneNumber = phoneNumberTextField.text {
            userDataArray["phone_number"] = phoneNumber
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

extension EditUserInfoVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Set Text Field Inputs
    
    func setTextFieldInputs() {
        stateTextField.inputView = statePickerView
    }
    
    //MARK: Set Delegates
    
    func setDelegates() {
        firmNameTextField.delegate = self
        taxpayerIDTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        
        statePickerView.delegate = self
    }
    
    //MARK: Text Restriction Function
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firmNameTextField {
            return Utils.restrictTextLength(by: 40, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == addressTextField || textField == cityTextField {
            return Utils.restrictTextLength(by: 30, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == phoneNumberTextField {
            return Utils.restrictTextLengthAndCharacters(by: 10, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == taxpayerIDTextField {
            return Utils.restrictTextLengthAndCharacters(by: 9, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == zipTextField {
            return Utils.restrictTextLengthAndCharacters(by: 5, textField, shouldChangeCharactersIn: range, replacementString: string)
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
