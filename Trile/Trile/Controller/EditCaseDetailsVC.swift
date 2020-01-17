//
//  EditCaseDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/3/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditCaseDetailsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fileNumberTextField: UITextField!
    @IBOutlet weak var bondTextField: UITextField!
    @IBOutlet weak var continuancesTextField: UITextField!
    @IBOutlet weak var desiredOutcomeTextField: UITextField!
    @IBOutlet weak var offenseTextField: UITextField!
    @IBOutlet weak var offenseClassTextField: UITextField!
    @IBOutlet weak var dispositionTextField: UITextField!
    @IBOutlet weak var judgmentAndSentencingTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var dateAppointedTextField: UITextField!
    @IBOutlet weak var dateOfFirstClientInterviewTextField: UITextField!
    @IBOutlet weak var dateOfFinalDispositionTextField: UITextField!
    @IBOutlet weak var nameOfJudgeSettingFeeTextField: UITextField!
    
    @IBOutlet weak var timeInCourtHoursTextField: UITextField!
    @IBOutlet weak var timeInCourtMinutesTextField: UITextField!
    @IBOutlet weak var timeInCourtWaitingHoursTextField: UITextField!
    @IBOutlet weak var timeInCourtWaitingMinutesTextField: UITextField!
    @IBOutlet weak var timeOutOfCourtHoursTextField: UITextField!
    @IBOutlet weak var timeOutOfCourtMinutesTextField: UITextField!
    
    @IBOutlet weak var caseInformationView: UIView!
    @IBOutlet weak var billableHoursView: UIView!
    
    let desiredOutcomePickerView = UIPickerView()
    let offensePickerView = UIPickerView()
    let offenseClassPickerView = UIPickerView()
    let dispositionPickerView = UIPickerView()
    let sentencePickerView = UIPickerView()
    let nameOfJudgeSettingFeePickerView = UIPickerView()
    let timeInCourtHoursPickerView = UIPickerView()
    let timeInCourtMinutesPickerView = UIPickerView()
    let timeInCourtWaitingHoursPickerView = UIPickerView()
    let timeInCourtWaitingMinutesPickerView = UIPickerView()
    let timeOutOfCourtHoursPickerView = UIPickerView()
    let timeOutOfCourtMinutesPickerView = UIPickerView()
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var textFieldArray = [UITextField]()
    var pickerViewArray = [UIPickerView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appendTextFields()
        appendPickerViews()
        setPickerViews()
        setDelegates()
        setTextFieldCursorTint()
        addCornerRadiusToViews()
        setPickerViewBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.readCaseDataFromDatabase(client, fileNumber) { (caseData, success) in
                self.readCaseData(from: caseData)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCaseData()
    }

    //MARK: Text Functions
    
    func setTextFieldCursorTint() {
        for textField in textFieldArray {
            textField.tintColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fileNumberTextField || textField == countyTextField || textField == nameOfJudgeSettingFeeTextField {
            return TextRestrictionManager.restrictTextLength(by: 20, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == bondTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 10, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == continuancesTextField || textField == timeInCourtHoursTextField || textField == timeInCourtMinutesTextField || textField == timeInCourtWaitingHoursTextField || textField == timeInCourtWaitingMinutesTextField || textField == timeOutOfCourtHoursTextField || textField == timeOutOfCourtMinutesTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 2, textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return true
    }
    
    //MARK: Delegate Set Methods
    
    func setDelegates() {
        for textField in textFieldArray {
            textField.delegate = self
        }
        
        for pickerView in pickerViewArray {
            pickerView.delegate = self
        }
    }
    
    //MARK: - Picker View Delegate Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch pickerView {
//        case desiredOutcomePickerView:
//            return desiredOutcomePickerList.count
//        default:
//            return 1
//        }
        return PickerListManager.desiredOutcomeList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch pickerView {
//        case desiredOutcomePickerView:
//            return desiredOutcomePickerList[row].name
//
//        default:
//            return "Title not found"
//        }
        return PickerListManager.desiredOutcomeList[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch pickerView {
//        case desiredOutcomePickerView:
//            desiredOutcomeText.text = desiredOutcomePickerList[row].name
//
//        }
        desiredOutcomeTextField.text = PickerListManager.desiredOutcomeList[row]
    }
    
    //MARK: - PickerView Set Input Views
    
    func setPickerViews() {
        desiredOutcomeTextField.inputView = desiredOutcomePickerView
//        for i in 0...(pickerViewsArray.count - 1) {
//            textFieldsWithPickersArray[i].inputView = pickerViewsArray[i]
//        }
    }
    
    //MARK: UI Beautification Functions
    
    func setPickerViewBackgroundColor() {
        desiredOutcomePickerView.backgroundColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: PickerListManager.desiredOutcomeList[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
    }
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        caseInformationView.layer.masksToBounds = true
        caseInformationView.layer.cornerRadius = cornerRadiusValue
        
        billableHoursView.layer.masksToBounds = true
        billableHoursView.layer.cornerRadius = cornerRadiusValue
    }
    
    //MARK: Read Case Data
    
    func readCaseData(from data: [String: Any]) {
        
        if let fileNumber = data["assigned_file_number"] {
            fileNumberTextField.text = fileNumber as? String
        }
        
        if let bond = data["bond"] {
            bondTextField.text = bond as? String
        }
        
        if let continuances = data["continuances"] {
            continuancesTextField.text = continuances as? String
        }
        
        if let desiredOutcome = data["desired_outcome"] {
            desiredOutcomeTextField.text = desiredOutcome as? String
        }
        
        if let offense = data["offense"] {
            offenseTextField.text = offense as? String
        }
        
        if let offenseClass = data["offense_class"] {
            offenseClassTextField.text = offenseClass as? String
        }
        
        if let disposition = data["disposition"] {
            dispositionTextField.text = disposition as? String
        }
        
        if let judgmentAndSentencing = data["judgment_and_sentencing"] {
            judgmentAndSentencingTextField.text = judgmentAndSentencing as? String
        }
        
        if let county = data["county"] {
            countyTextField.text = county as? String
        }
        
        if let dateAppointed = data["date_appointed"] {
            dateAppointedTextField.text = dateAppointed as? String
        }
        
        if let dateOfFirstClientInterview = data["date_of_first_client_interview"] {
            dateOfFirstClientInterviewTextField.text = dateOfFirstClientInterview as? String
        }
        
        if let dateOfFinalDisposition = data["date_of_final_disposition"] {
            dateOfFinalDispositionTextField.text = dateOfFinalDisposition as? String
        }
        
        if let nameOfJudgeSettingFee = data["name_of_judge_setting_fee"] {
            nameOfJudgeSettingFeeTextField.text = nameOfJudgeSettingFee as? String
        }
        
        if let timeInCourtHours = data["time_in_court_hours"] {
            timeInCourtHoursTextField.text = timeInCourtHours as? String
        }
        
        if let timeInCourtMinutes = data["time_in_court_minutes"] {
            timeInCourtMinutesTextField.text = timeInCourtMinutes as? String
        }
        
        if let timeInCourtWaitingHours = data["time_in_court_waiting_hours"] {
            timeInCourtWaitingHoursTextField.text = timeInCourtWaitingHours as? String
        }

        if let timeInCourtWaitingMinutes = data["time_in_court_waiting_minutes"] {
            timeInCourtWaitingMinutesTextField.text = timeInCourtWaitingMinutes as? String
        }
        
        if let timeOutOfCourtHours = data["time_out_of_court_hours"] {
            timeOutOfCourtHoursTextField.text = timeOutOfCourtHours as? String
        }
        
        if let timeOutOfCourtMinutes = data["time_out_of_court_minutes"] {
            timeOutOfCourtMinutesTextField.text = timeOutOfCourtMinutes as? String
        }
    }
    
    //MARK: Save Case Data
    
    func saveCaseData() {
        var caseDataArray = [String: Any]()
        
        if let fileNumber = fileNumberTextField.text {
            caseDataArray["assigned_file_number"] = fileNumber
        }
        
        if let bond = bondTextField.text {
            caseDataArray["bond"] = bond
        }
        
        if let continuances = continuancesTextField.text {
            caseDataArray["continuances"] = continuances
        }
        
        if let desiredOutcome = desiredOutcomeTextField.text {
            caseDataArray["desired_outcome"] = desiredOutcome
        }
        
        if let offense = offenseTextField.text {
            caseDataArray["offense"] = offense
        }
        
        if let offenseClass = offenseClassTextField.text {
            caseDataArray["offense_class"] = offenseClass
        }
        
        if let disposition = dispositionTextField.text {
            caseDataArray["disposition"] = disposition
        }
        
        if let judgmentAndSentencing = judgmentAndSentencingTextField.text {
            caseDataArray["judgment_and_sentencing"] = judgmentAndSentencing
        }
        
        if let county = countyTextField.text {
            caseDataArray["county"] = county
        }
        
        if let dateAppointed = dateAppointedTextField.text {
            caseDataArray["date_appointed"] = dateAppointed
        }
        
        if let dateOfFirstInterview = dateOfFirstClientInterviewTextField.text {
            caseDataArray["date_of_first_client_interview"] = dateOfFirstInterview
        }
        
        if let dateOfFinalDisposition = dateOfFinalDispositionTextField.text {
            caseDataArray["date_of_final_disposition"] = dateOfFinalDisposition
        }
        
        if let nameOfJudgeSettingFee = nameOfJudgeSettingFeeTextField.text {
            caseDataArray["name_of_judge_setting_fee"] = nameOfJudgeSettingFee
        }
        
        if let timeInCourtHours = timeInCourtHoursTextField.text {
            caseDataArray["time_in_court_hours"] = timeInCourtHours
        }
        
        if let timeInCourtMinutes = timeInCourtMinutesTextField.text {
            caseDataArray["time_in_court_minutes"] = timeInCourtMinutes
        }
        
        if let timeInCourtWaitingHours = timeInCourtWaitingHoursTextField.text {
            caseDataArray["time_in_court_waiting_hours"] = timeInCourtWaitingHours
        }
        
        if let timeInCourtWaitingMinutes = timeInCourtWaitingMinutesTextField.text {
            caseDataArray["time_in_court_waiting_minutes"] = timeInCourtWaitingMinutes
        }
        
        if let timeOutOfCourtHours = timeOutOfCourtHoursTextField.text {
            caseDataArray["time_out_of_court_hours"] = timeOutOfCourtHours
        }
        
        if let timeOutOfCourtMinutes = timeOutOfCourtMinutesTextField.text {
            caseDataArray["time_out_of_court_minutes"] = timeOutOfCourtMinutes
        }
        
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.addCaseDataToDatabase(client, fileNumber, caseDataArray)
        }
    }
    
    //MARK: Append TextFields
    
    func appendTextFields() {
        //Append textfields so other functions can iterate through them when setting properties
        textFieldArray.append(fileNumberTextField)
        textFieldArray.append(bondTextField)
        textFieldArray.append(continuancesTextField)
        textFieldArray.append(desiredOutcomeTextField)
        textFieldArray.append(offenseTextField)
        textFieldArray.append(offenseClassTextField)
        textFieldArray.append(dispositionTextField)
        textFieldArray.append(judgmentAndSentencingTextField)
        textFieldArray.append(countyTextField)
        textFieldArray.append(dateAppointedTextField)
        textFieldArray.append(dateOfFirstClientInterviewTextField)
        textFieldArray.append(dateOfFinalDispositionTextField)
        textFieldArray.append(nameOfJudgeSettingFeeTextField)
        textFieldArray.append(timeInCourtHoursTextField)
        textFieldArray.append(timeInCourtMinutesTextField)
        textFieldArray.append(timeInCourtWaitingHoursTextField)
        textFieldArray.append(timeInCourtWaitingMinutesTextField)
        textFieldArray.append(timeOutOfCourtHoursTextField)
        textFieldArray.append(timeOutOfCourtMinutesTextField)
    }
    
    //MARK: Append PickerViews
    
    func appendPickerViews() {
        pickerViewArray.append(desiredOutcomePickerView)
        pickerViewArray.append(offensePickerView)
        pickerViewArray.append(offenseClassPickerView)
        pickerViewArray.append(dispositionPickerView)
        pickerViewArray.append(sentencePickerView)
        pickerViewArray.append(timeInCourtHoursPickerView)
        pickerViewArray.append(timeInCourtMinutesPickerView)
        pickerViewArray.append(timeInCourtWaitingHoursPickerView)
        pickerViewArray.append(timeInCourtWaitingMinutesPickerView)
        pickerViewArray.append(timeOutOfCourtHoursPickerView)
        pickerViewArray.append(timeOutOfCourtMinutesPickerView)
    }
}
