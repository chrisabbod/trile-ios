//
//  EditClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/2/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditClientDetailsVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var clientPictureImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var highestEducationTextField: UITextField!
    @IBOutlet weak var areaOfStudyTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var placeOfEmploymentTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var dateStartedTextField: UITextField!
    @IBOutlet weak var dateEndedTextField: UITextField!
    @IBOutlet weak var incomeRangeTextField: UITextField!
    
    @IBOutlet weak var totalChildrenTextField: UITextField!
    @IBOutlet weak var totalOtherOccupantsTextField: UITextField!
    
    @IBOutlet weak var clientInformationView: UIView!
    @IBOutlet weak var workHistoryView: UIView!
    @IBOutlet weak var householdResidentsView: UIView!
    
    let NOTIFICATION_VALUE = "loadClientTableVC"

    let highestEducationPickerView = UIPickerView()
    let areaOfStudyPickerView = UIPickerView()
    let statePickerView = UIPickerView()
    let incomeRangePickerView = UIPickerView()
    
    let dateStartedDatePicker = UIDatePicker()
    let dateEndedDatePicker = UIDatePicker()
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    let imageManager = FirebaseStorageManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var textFieldArray = [UITextField]()
    var pickerViewArray = [UIPickerView]()
    var datePickerArray = [UIDatePicker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextFieldAndPickerViewArrays()
        setTextFieldAndPickerViewDelegates()
        setTextFieldInputViewsAsPickerViews()
        setTextFieldInputViewsAsDatePickerViews()
        setDatePickerProperties()
        
        beautifyUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClientData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveClientData()
        
        //Calls Notification Function in ClientTableVC to reload data
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
    }
    
    //MARK: Bar Button Functions
    
    @IBAction func cameraButton(_ sender: Any) {
        let imagePicker =  UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Camera Function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        clientPictureImageView.image = image
        
        if let client = selectedClient {
            imageManager.uploadClientImageToStorage(client, image) { (success) in
                if success {
                    print("Client image uploaded successfully!")
                }
            }
        }
    }
    
    //MARK: Load Client Data
    
    func loadClientData() {
        if let client = selectedClient {
            dbm.readClientDataFromDatabase(client) { (documentData, success) in
                if success {
                    self.readClientData(from: documentData)
                    
                    if let imagePath = documentData["image_path"] {
                        client.imagePath = imagePath as! String
                        self.imageManager.downloadClientImageFromStorage(client) { (imageData, success) in
                            if success {
                                print("Successfully read client image data")
                                self.clientPictureImageView.image = UIImage(data: imageData)
                            } else {
                                print("Problem reading client image data")
                            }
                        }
                    }
                } else {
                    print("Problem reading client data")
                }
            }
        }
    }
    
    //MARK: Set Delegates
    
    func setTextFieldAndPickerViewDelegates() {
        for textField in textFieldArray {
            textField.delegate = self
        }
        
        for pickerView in pickerViewArray {
            pickerView.delegate = self
        }
    }
    
    //MARK: Set PickerView Input Views
    
    func setTextFieldInputViewsAsPickerViews() {
        highestEducationTextField.inputView = highestEducationPickerView
        areaOfStudyTextField.inputView = areaOfStudyPickerView
        stateTextField.inputView = statePickerView
        incomeRangeTextField.inputView = incomeRangePickerView
    }
    
    //MARK: Set DatePicker Input Views
    
    func setTextFieldInputViewsAsDatePickerViews() {
        dateStartedTextField.inputView = dateStartedDatePicker
        dateEndedTextField.inputView = dateEndedDatePicker
    }
    
    //MARK: Text Restriction Function
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == addressTextField || textField == cityTextField || textField == placeOfEmploymentTextField || textField == roleTextField {
            return TextRestrictionManager.restrictTextLength(by: 30, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == nameTextField || textField == areaOfStudyTextField {
            return TextRestrictionManager.restrictTextLengthAndNumbers(by: 20, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == phoneNumberTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 10, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == zipTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 5, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == ageTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 3, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == totalChildrenTextField || textField == totalOtherOccupantsTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 2, textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return true
    }
    
    //MARK: - Picker View Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case highestEducationPickerView:
            return PickerListManager.highestEducationList.count
        case areaOfStudyPickerView:
            return PickerListManager.areaOfStudyList.count
        case statePickerView:
            return PickerListManager.statesList.count
        case incomeRangePickerView:
            return PickerListManager.incomeRangeList.count
        default:
            return 1
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case highestEducationPickerView:
            return PickerListManager.highestEducationList[row]
        case areaOfStudyPickerView:
            return PickerListManager.areaOfStudyList[row]
        case statePickerView:
            return PickerListManager.statesList[row]
        case incomeRangePickerView:
            return PickerListManager.incomeRangeList[row]
        default:
            return "List Not Found"
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case highestEducationPickerView:
            highestEducationTextField.text = PickerListManager.highestEducationList[row]
        case areaOfStudyPickerView:
            areaOfStudyTextField.text = PickerListManager.areaOfStudyList[row]
        case statePickerView:
            stateTextField.text = PickerListManager.statesList[row]
        case incomeRangePickerView:
            incomeRangeTextField.text = PickerListManager.incomeRangeList[row]
        default:
            print("No Picker View Found")
        }
    }
    
    //MARK: Date Picker Functions
    
    func setDatePickerProperties() {
        for datePicker in datePickerArray {
            datePicker.datePickerMode = .date
            datePicker.timeZone = NSTimeZone.local
        }
        dateStartedDatePicker.addTarget(self, action: #selector(dateStartedPickerChanged(picker:)), for: .valueChanged)
        dateEndedDatePicker.addTarget(self, action: #selector(dateEndedPickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc
    func dateStartedPickerChanged(picker: UIDatePicker) {
        
        dateStartedTextField.text = DateManager.formatDateToString(picker.date)
    }
    
    @objc
    func dateEndedPickerChanged(picker: UIDatePicker) {
        dateEndedTextField.text = DateManager.formatDateToString(picker.date)
    }
    
    //MARK: UI Beautification Functions
    
    func beautifyUI() {
        setTextFieldCursorTint()
        setPickerViewBackgroundColor()
        setDatePickerBackgroundColor()
        makeCircularView()
        addCornerRadiusToViews()
    }
    
    func setTextFieldCursorTint() {
        for textField in textFieldArray {
            textField.tintColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        }
    }
    
    func setPickerViewBackgroundColor() {
        for picker in pickerViewArray {
            picker.backgroundColor  = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        }
    }
    
    func setDatePickerBackgroundColor() {
        for datePicker in datePickerArray {
            datePicker.backgroundColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        }
    }
    
    func makeCircularView() {
        clientPictureImageView.layer.masksToBounds = true
        clientPictureImageView.layer.cornerRadius = clientPictureImageView.bounds.width / 2
    }
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        clientInformationView.layer.masksToBounds = true
        clientInformationView.layer.cornerRadius = cornerRadiusValue
        
        workHistoryView.layer.masksToBounds = true
        workHistoryView.layer.cornerRadius = cornerRadiusValue
        
        householdResidentsView.layer.masksToBounds = true
        householdResidentsView.layer.cornerRadius = cornerRadiusValue
    }
    
    //MARK: Read Client Data
    
    func readClientData(from data: [String: Any]) {
        
        if let name = data["name"] {
            nameTextField.text = name as? String
        }
        
        if let age = data["age"] {
            ageTextField.text = age as? String
        }
        
        if let highestEducation = data["highest_education"] {
            highestEducationTextField.text = highestEducation as? String
        }
        
        if let areaOfStudy = data["area_of_study"] {
            areaOfStudyTextField.text = areaOfStudy as? String
        }
        
        if let phoneNumber = data["phone_number"] {
            phoneNumberTextField.text = phoneNumber as? String
        }
        
        if let address = data["address"] {
            addressTextField.text = address as? String
        }
        
        if let city = data["city"] {
            cityTextField.text = city as? String
        }
        
        if let state = data["state"] {
            stateTextField.text = state as? String
        }
        
        if let zip = data["zip"] {
            zipTextField.text = zip as? String
        }
        
        if let placeOfEmployment = data["place_of_employment"] {
            placeOfEmploymentTextField.text = placeOfEmployment as? String
        }
        
        if let role = data["role"] {
            roleTextField.text = role as? String
        }
        
        if let dataStarted = data["date_started"] {
            dateStartedTextField.text = dataStarted as? String
        }
        
        if let dateEnded = data["date_ended"] {
            dateEndedTextField.text = dateEnded as? String
        }
        
        if let incomeRange = data["income_range"] {
            incomeRangeTextField.text = incomeRange as? String
        }
        
        if let totalChildren = data["total_children"] {
            totalChildrenTextField.text = totalChildren as? String
        }
        
        if let totalOtherOccupants = data["total_other_occupants"] {
            totalOtherOccupantsTextField.text = totalOtherOccupants as? String
        }
    }
    
    //MARK: Save Client Data
    
    func saveClientData() {
        var clientDataArray = [String: Any]()
        
        if let name = nameTextField.text {
            clientDataArray["name"] = name
        }
        
        if let age = ageTextField.text {
            clientDataArray["age"] = age
        }
        
        if let highestEducation = highestEducationTextField.text {
            clientDataArray["highest_education"] = highestEducation
        }
        
        if let areaOfStudy = areaOfStudyTextField.text {
            clientDataArray["area_of_study"] = areaOfStudy
        }
        
        if let phoneNumber = phoneNumberTextField.text {
            clientDataArray["phone_number"] = phoneNumber
        }
        
        if let address = addressTextField.text {
            clientDataArray["address"] = address
        }
        
        if let city = cityTextField.text {
            clientDataArray["city"] = city
        }
        
        if let state = stateTextField.text {
            clientDataArray["state"] = state
        }
        
        if let zip = zipTextField.text {
            clientDataArray["zip"] = zip
        }
        
        if let placeOfEmployment = placeOfEmploymentTextField.text {
            clientDataArray["place_of_employment"] = placeOfEmployment
        }
        
        if let role = roleTextField.text {
            clientDataArray["role"] = role
        }
        
        if let dateStarted = dateStartedTextField.text {
            clientDataArray["date_started"] = dateStarted
        }
        
        if let dateEnded = dateEndedTextField.text {
            clientDataArray["date_ended"] = dateEnded
        }
        
        if let incomeRange = incomeRangeTextField.text {
            clientDataArray["income_range"] = incomeRange
        }
        
        if let totalChildren = totalChildrenTextField.text {
            clientDataArray["total_children"] = totalChildren
        }
        
        if let totalOtherOccupants = totalOtherOccupantsTextField.text {
            clientDataArray["total_other_occupants"] = totalOtherOccupants
        }
        
        if let client = selectedClient {
            dbm.addClientDataToDatabase(client, clientDataArray)
        }
    }
    
    //MARK: Append TextFields
    
    func createTextFieldAndPickerViewArrays() {
        //Append textfields so other functions can iterate through them when setting properties
        textFieldArray.append(nameTextField)
        textFieldArray.append(ageTextField)
        textFieldArray.append(highestEducationTextField)
        textFieldArray.append(areaOfStudyTextField)
        textFieldArray.append(phoneNumberTextField)
        textFieldArray.append(addressTextField)
        textFieldArray.append(cityTextField)
        textFieldArray.append(zipTextField)
        textFieldArray.append(placeOfEmploymentTextField)
        textFieldArray.append(roleTextField)
        textFieldArray.append(dateStartedTextField)
        textFieldArray.append(dateEndedTextField)
        textFieldArray.append(totalChildrenTextField)
        textFieldArray.append(totalOtherOccupantsTextField)
        
        pickerViewArray.append(highestEducationPickerView)
        pickerViewArray.append(areaOfStudyPickerView)
        pickerViewArray.append(statePickerView)
        pickerViewArray.append(incomeRangePickerView)
        
        datePickerArray.append(dateStartedDatePicker)
        datePickerArray.append(dateEndedDatePicker)
    }
}
