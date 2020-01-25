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
    @IBOutlet weak var offenseCategoryTextField: UITextField!
    @IBOutlet weak var offenseClassTextField: UITextField!
    @IBOutlet weak var dispositionTextField: UITextField!
    @IBOutlet weak var otherOffenseTextField: UITextField!
    @IBOutlet weak var judgmentAndSentencingTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var nameOfJudgeSettingFeeTextField: UITextField!
    @IBOutlet weak var sentenceMonthsTextField: UITextField!
    @IBOutlet weak var sentenceDaysTextField: UITextField!
    @IBOutlet weak var dateAppointedTextField: UITextField!
    @IBOutlet weak var dateOfFirstClientInterviewTextField: UITextField!
    @IBOutlet weak var dateOfFinalDispositionTextField: UITextField!
    
    @IBOutlet weak var timeInCourtHoursTextField: UITextField!
    @IBOutlet weak var timeInCourtMinutesTextField: UITextField!
    @IBOutlet weak var timeInCourtWaitingHoursTextField: UITextField!
    @IBOutlet weak var timeInCourtWaitingMinutesTextField: UITextField!
    @IBOutlet weak var timeOutOfCourtHoursTextField: UITextField!
    @IBOutlet weak var timeOutOfCourtMinutesTextField: UITextField!
    @IBOutlet weak var travelTextField: UITextField!
    @IBOutlet weak var copyingTextField: UITextField!
    @IBOutlet weak var otherExpensesTextField: UITextField!
    
    @IBOutlet weak var caseInformationView: UIView!
    @IBOutlet weak var billableHoursView: UIView!
    @IBOutlet weak var expensesView: UIView!
    
    @IBOutlet weak var otherOffenseStackView: UIStackView!
    @IBOutlet weak var sentenceLengthStackView: UIStackView!
    
    let OFFENSE_SEGUE = "goToOffenseTableVC"
    let NOTIFICATION_VALUE = "loadFileNumberTableVC"

    let desiredOutcomePickerView = UIPickerView()
    let offenseCategoryPickerView = UIPickerView()
    let offenseClassPickerView = UIPickerView()
    let dispositionPickerView = UIPickerView()
    let judgmentAndSentencingPickerView = UIPickerView()
    let countyPickerView = UIPickerView()
    let nameOfJudgeSettingFeePickerView = UIPickerView()
    let timeInCourtHoursPickerView = UIPickerView()
    let timeInCourtMinutesPickerView = UIPickerView()
    let timeInCourtWaitingHoursPickerView = UIPickerView()
    let timeInCourtWaitingMinutesPickerView = UIPickerView()
    let timeOutOfCourtHoursPickerView = UIPickerView()
    let timeOutOfCourtMinutesPickerView = UIPickerView()
    
    let dateAppointedDatePicker = UIDatePicker()
    let dateOfFirstClientInverviewDatepicker = UIDatePicker()
    let dateofFinalDispositionDatePicker = UIDatePicker()
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var textFieldArray = [UITextField]()
    var pickerViewArray = [UIPickerView]()
    var datePickerArray = [UIDatePicker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTextFieldAndPickerViewArrays()
        setTextFieldAndPickerViewDelegates()
        hideKeyboardWhenClickingOnTextField()
        setTextFieldInputViewsAsPickerViews()
        setTextFieldInputViewsAsDatePickerViews()
        setDatePickerProperties()
        
        beautifyUI()

        offenseTextField.addTarget(self, action: #selector(offenseTableSegue), for: .editingDidBegin)
        otherOffenseTextField.addTarget(self, action: #selector(offenseTableSegue), for: .editingDidBegin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fileNumberTextField.becomeFirstResponder()
        
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.readCaseDataFromDatabase(client, fileNumber) { (caseData, success) in
                self.readCaseData(from: caseData)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCaseData()
        
        //Calls Notification Function in FileNumberTableVC to reload data
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
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
    
    //MARK: Hide Keyboard Function
    
    func hideKeyboardWhenClickingOnTextField() {
        offenseTextField.inputView = UIView()
        offenseTextField.inputAccessoryView = UIView()
    }
    
    //MARK: PickerView Set Input Views
    
    func setTextFieldInputViewsAsPickerViews() {
        desiredOutcomeTextField.inputView = desiredOutcomePickerView
        offenseCategoryTextField.inputView = offenseCategoryPickerView
        offenseClassTextField.inputView = offenseClassPickerView
        dispositionTextField.inputView = dispositionPickerView
        judgmentAndSentencingTextField.inputView = judgmentAndSentencingPickerView
        countyTextField.inputView = countyPickerView
        nameOfJudgeSettingFeeTextField.inputView = nameOfJudgeSettingFeePickerView
        timeInCourtHoursTextField.inputView = timeInCourtHoursPickerView
        timeInCourtMinutesTextField.inputView = timeInCourtMinutesPickerView
        timeInCourtWaitingHoursTextField.inputView = timeInCourtWaitingHoursPickerView
        timeInCourtWaitingMinutesTextField.inputView = timeInCourtWaitingMinutesPickerView
        timeOutOfCourtHoursTextField.inputView = timeOutOfCourtHoursPickerView
        timeOutOfCourtMinutesTextField.inputView = timeOutOfCourtMinutesPickerView
    }
    
    //MARK: DatePicker Set Input Views
    
    func setTextFieldInputViewsAsDatePickerViews() {
        dateAppointedTextField.inputView = dateAppointedDatePicker
        dateOfFirstClientInterviewTextField.inputView = dateOfFirstClientInverviewDatepicker
        dateOfFinalDispositionTextField.inputView = dateofFinalDispositionDatePicker
    }
    
    //MARK: Text Restriction Function
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fileNumberTextField || textField == countyTextField || textField == nameOfJudgeSettingFeeTextField {
            return TextRestrictionManager.restrictTextLength(by: 20, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == bondTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 10, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == sentenceMonthsTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 4, textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == continuancesTextField || textField == sentenceDaysTextField || textField == timeInCourtHoursTextField || textField == timeInCourtMinutesTextField || textField == timeInCourtWaitingHoursTextField || textField == timeInCourtWaitingMinutesTextField || textField == timeOutOfCourtHoursTextField || textField == timeOutOfCourtMinutesTextField {
            return TextRestrictionManager.restrictTextLengthAndCharacters(by: 2, textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return true
    }
    
    //MARK: Segue Functions
    
    @objc
    func offenseTableSegue() {
        performSegue(withIdentifier: OFFENSE_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! OffenseTableVC
        destinationVC.selectedClient = selectedClient
        destinationVC.selectedFileNumber = selectedFileNumber
        if offenseTextField.isEditing {
            print("Clicked offense text field")
            destinationVC.offenseClicked = true
        } else if otherOffenseTextField.isEditing {
            print("Clicked other offense text field")
            destinationVC.otherOffenseClicked = true
        }
        
    }
    
    //MARK: PickerView Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case desiredOutcomePickerView:
            return PickerListManager.desiredOutcomeList.count
        case offenseCategoryPickerView:
            return PickerListManager.offenseCategoryList.count
        case offenseClassPickerView:
            return PickerListManager.offenseClassList.count
        case dispositionPickerView:
            return PickerListManager.dispositionList.count
        case judgmentAndSentencingPickerView:
            return PickerListManager.judgmentAndSentencingList.count
        case countyPickerView:
            return PickerListManager.countyList.count
        case nameOfJudgeSettingFeePickerView:
            if countyTextField.text == "Gaston" {
                return PickerListManager.gastonJudgeList.count
            } else {
                return PickerListManager.clevelandLincolnJudgeList.count
            }
        case timeInCourtHoursPickerView:
            return PickerListManager.hoursPickerList().count
        case timeInCourtMinutesPickerView:
            return PickerListManager.minutesPickerList().count
        case timeInCourtWaitingHoursPickerView:
            return PickerListManager.hoursPickerList().count
        case timeInCourtWaitingMinutesPickerView:
            return PickerListManager.minutesPickerList().count
        case timeOutOfCourtHoursPickerView:
            return PickerListManager.hoursPickerList().count
        case timeOutOfCourtMinutesPickerView:
            return PickerListManager.minutesPickerList().count
        default:
            return 1
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case desiredOutcomePickerView:
            return PickerListManager.desiredOutcomeList[row]
        case offenseCategoryPickerView:
            return PickerListManager.offenseCategoryList[row]
        case offenseClassPickerView:
            return PickerListManager.offenseClassList[row]
        case dispositionPickerView:
            return PickerListManager.dispositionList[row]
        case judgmentAndSentencingPickerView:
            return PickerListManager.judgmentAndSentencingList[row]
        case countyPickerView:
            return PickerListManager.countyList[row]
        case nameOfJudgeSettingFeePickerView:
            if countyTextField.text == "Gaston" {
                return PickerListManager.gastonJudgeList[row]
            } else {
                return PickerListManager.clevelandLincolnJudgeList[row]
            }
        case timeInCourtHoursPickerView:
            return PickerListManager.hoursPickerList()[row]
        case timeInCourtMinutesPickerView:
            return PickerListManager.minutesPickerList()[row]
        case timeInCourtWaitingHoursPickerView:
            return PickerListManager.hoursPickerList()[row]
        case timeInCourtWaitingMinutesPickerView:
            return PickerListManager.minutesPickerList()[row]
        case timeOutOfCourtHoursPickerView:
            return PickerListManager.hoursPickerList()[row]
        case timeOutOfCourtMinutesPickerView:
            return PickerListManager.minutesPickerList()[row]
        default:
            return "List Not Found"
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case desiredOutcomePickerView:
            desiredOutcomeTextField.text = PickerListManager.desiredOutcomeList[row]
        case offenseCategoryPickerView:
            offenseCategoryTextField.text = PickerListManager.offenseCategoryList[row]
        case offenseClassPickerView:
            offenseClassTextField.text = PickerListManager.offenseClassList[row]
        case dispositionPickerView:
            dispositionTextField.text = PickerListManager.dispositionList[row]
            if let disposition = dispositionTextField.text {
                showOtherOffense(disposition)
            }
        case judgmentAndSentencingPickerView:
            judgmentAndSentencingTextField.text = PickerListManager.judgmentAndSentencingList[row]
            if let sentence = judgmentAndSentencingTextField.text {
                showSentenceLength(sentence)
            }
        case countyPickerView:
            countyTextField.text = PickerListManager.countyList[row]
        case nameOfJudgeSettingFeePickerView:
            if countyTextField.text == "Gaston" {
                nameOfJudgeSettingFeeTextField.text = PickerListManager.gastonJudgeList[row]
            } else {
                nameOfJudgeSettingFeeTextField.text = PickerListManager.clevelandLincolnJudgeList[row]
            }
        case timeInCourtHoursPickerView:
            timeInCourtHoursTextField.text = PickerListManager.hoursPickerList()[row]
        case timeInCourtMinutesPickerView:
            timeInCourtMinutesTextField.text = PickerListManager.minutesPickerList()[row]
        case timeInCourtWaitingHoursPickerView:
            timeInCourtWaitingHoursTextField.text = PickerListManager.hoursPickerList()[row]
        case timeInCourtWaitingMinutesPickerView:
            timeInCourtWaitingMinutesTextField.text = PickerListManager.minutesPickerList()[row]
        case timeOutOfCourtHoursPickerView:
            timeOutOfCourtHoursTextField.text = PickerListManager.hoursPickerList()[row]
        case timeOutOfCourtMinutesPickerView:
            timeOutOfCourtMinutesTextField.text = PickerListManager.minutesPickerList()[row]
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
        dateAppointedDatePicker.addTarget(self, action: #selector(dateAppointedPickerChanged(picker:)), for: .valueChanged)
        dateOfFirstClientInverviewDatepicker.addTarget(self, action: #selector(dateOfFirstClientInterviewPickerChanged(picker:)), for: .valueChanged)
        dateofFinalDispositionDatePicker.addTarget(self, action: #selector(dateOfFinalDispositionPickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc
    func dateAppointedPickerChanged(picker: UIDatePicker) {
        dateAppointedTextField.text = DateFormatterManager.formatDateToString(picker.date)
    }
    
    @objc
    func dateOfFirstClientInterviewPickerChanged(picker: UIDatePicker) {
        dateOfFirstClientInterviewTextField.text = DateFormatterManager.formatDateToString(picker.date)
    }
    
    @objc
    func dateOfFinalDispositionPickerChanged(picker: UIDatePicker) {
        dateOfFinalDispositionTextField.text = DateFormatterManager.formatDateToString(picker.date)
    }
    
    //MARK: Show/Hide Functions
    
    func showSentenceLength(_ judgment: String) {
        if judgment == "Active Sentence" {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.sentenceLengthStackView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.sentenceLengthStackView.isHidden = true
            }
        }
    }
    
    func showOtherOffense(_ disposition: String) {
        if disposition == "Guilty Plea Before Trial: Other Offense" ||
            disposition == "Guilty Plea During Trial: Other Offense" ||
            disposition == "Trial: Guilty Other Offense" {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.otherOffenseStackView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.35) { [unowned self] in
                self.otherOffenseStackView.isHidden = true
            }
        }
    }
    
    //MARK: UI Beautification Functions
    
    func beautifyUI() {
        setTextFieldCursorTint()
        setPickerViewBackgroundColor()
        setDatePickerBackgroundColor()
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
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        caseInformationView.layer.masksToBounds = true
        caseInformationView.layer.cornerRadius = cornerRadiusValue
        
        billableHoursView.layer.masksToBounds = true
        billableHoursView.layer.cornerRadius = cornerRadiusValue

        expensesView.layer.masksToBounds = true
        expensesView.layer.cornerRadius = cornerRadiusValue
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
        
        if let offenseCategory = data["offense_category"] {
            offenseCategoryTextField.text = offenseCategory as? String
        }
        
        if let offenseClass = data["offense_class"] {
            offenseClassTextField.text = offenseClass as? String
        }
        
        if let disposition = data["disposition"] {
            dispositionTextField.text = disposition as? String
            
            showOtherOffense(disposition as! String)
        }
        
        if let otherOffense = data["other_offense"] {
            otherOffenseTextField.text = otherOffense as? String
        }
        
        if let judgmentAndSentencing = data["judgment_and_sentencing"] {
            judgmentAndSentencingTextField.text = judgmentAndSentencing as? String
            
            showSentenceLength(judgmentAndSentencing as! String)
        }
        
        if let sentenceMonths = data["sentence_months"] {
            sentenceMonthsTextField.text = sentenceMonths as? String
        }
        
        if let sentenceDays = data["sentence_days"] {
            sentenceDaysTextField.text = sentenceDays as? String
        }
        
        if let county = data["county"] {
            countyTextField.text = county as? String
        }
        
        if let nameOfJudgeSettingFee = data["name_of_judge_setting_fee"] {
            nameOfJudgeSettingFeeTextField.text = nameOfJudgeSettingFee as? String
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
        
        if let travelExpenses = data["travel_expenses"] {
            travelTextField.text = travelExpenses as? String
        }
        
        if let copyingExpenses = data["copying_expenses"] {
            copyingTextField.text = copyingExpenses as? String
        }
        
        if let otherExpenses = data["other_expenses"] {
            otherExpensesTextField.text = otherExpenses as? String
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
        
        if let offenseCategory = offenseCategoryTextField.text {
            caseDataArray["offense_category"] = offenseCategory
        }
        
        if let offenseClass = offenseClassTextField.text {
            caseDataArray["offense_class"] = offenseClass
        }
        
        if let disposition = dispositionTextField.text {
            caseDataArray["disposition"] = disposition
        }
        
        if let otherOffense = otherOffenseTextField.text {
            caseDataArray["other_offense"] = otherOffense
        }
        
        if let judgmentAndSentencing = judgmentAndSentencingTextField.text {
            caseDataArray["judgment_and_sentencing"] = judgmentAndSentencing
        }
        
        if let sentenceMonths = sentenceMonthsTextField.text {
            caseDataArray["sentence_months"] = sentenceMonths
        }
        
        if let sentenceDays = sentenceDaysTextField.text {
            caseDataArray["sentence_days"] = sentenceDays
        }
        
        if let county = countyTextField.text {
            caseDataArray["county"] = county
        }
        
        if let nameOfJudgeSettingFee = nameOfJudgeSettingFeeTextField.text {
            caseDataArray["name_of_judge_setting_fee"] = nameOfJudgeSettingFee
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
        
        if let travelExpenses = travelTextField.text {
            caseDataArray["travel_expenses"] = travelExpenses
        }
        
        if let copyingExpenses = copyingTextField.text {
            caseDataArray["copying_expenses"] = copyingExpenses
        }
        
        if let otherExpenses = otherExpensesTextField.text {
            caseDataArray["other_expenses"] = otherExpenses
        }
        
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.addCaseDataToDatabase(client, fileNumber, caseDataArray)
        }
    }
    
    //MARK: Textfield/Picker Array Setup
    
    func createTextFieldAndPickerViewArrays() {
        //Append textfields so other functions can iterate through them when setting properties
        
        textFieldArray.append(fileNumberTextField)
        textFieldArray.append(bondTextField)
        textFieldArray.append(continuancesTextField)
        textFieldArray.append(desiredOutcomeTextField)
        textFieldArray.append(offenseTextField)
        textFieldArray.append(offenseClassTextField)
        textFieldArray.append(dispositionTextField)
        textFieldArray.append(judgmentAndSentencingTextField)
        textFieldArray.append(sentenceMonthsTextField)
        textFieldArray.append(sentenceDaysTextField)
        textFieldArray.append(countyTextField)
        textFieldArray.append(nameOfJudgeSettingFeeTextField)
        textFieldArray.append(dateAppointedTextField)
        textFieldArray.append(dateOfFirstClientInterviewTextField)
        textFieldArray.append(dateOfFinalDispositionTextField)
        textFieldArray.append(timeInCourtHoursTextField)
        textFieldArray.append(timeInCourtMinutesTextField)
        textFieldArray.append(timeInCourtWaitingHoursTextField)
        textFieldArray.append(timeInCourtWaitingMinutesTextField)
        textFieldArray.append(timeOutOfCourtHoursTextField)
        textFieldArray.append(timeOutOfCourtMinutesTextField)
        textFieldArray.append(travelTextField)
        textFieldArray.append(copyingTextField)
        textFieldArray.append(otherExpensesTextField)
        
        pickerViewArray.append(desiredOutcomePickerView)
        pickerViewArray.append(offenseCategoryPickerView)
        pickerViewArray.append(offenseClassPickerView)
        pickerViewArray.append(dispositionPickerView)
        pickerViewArray.append(judgmentAndSentencingPickerView)
        pickerViewArray.append(countyPickerView)
        pickerViewArray.append(nameOfJudgeSettingFeePickerView)
        pickerViewArray.append(timeInCourtHoursPickerView)
        pickerViewArray.append(timeInCourtMinutesPickerView)
        pickerViewArray.append(timeInCourtWaitingHoursPickerView)
        pickerViewArray.append(timeInCourtWaitingMinutesPickerView)
        pickerViewArray.append(timeOutOfCourtHoursPickerView)
        pickerViewArray.append(timeOutOfCourtMinutesPickerView)
        
        datePickerArray.append(dateAppointedDatePicker)
        datePickerArray.append(dateOfFirstClientInverviewDatepicker)
        datePickerArray.append(dateofFinalDispositionDatePicker)
    }
}
