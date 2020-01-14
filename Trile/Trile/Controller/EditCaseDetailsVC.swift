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

class EditCaseDetailsVC: UIViewController {

    @IBOutlet weak var fileNumberTextField: UITextField!
    @IBOutlet weak var bondTextField: UITextField!
    @IBOutlet weak var continuanceTextField: UITextField!
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
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = DatabaseManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCornerRadiusToViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readCaseDataFromDatabase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCaseData()
    }

    //MARK: Database CRUD Functions
    
    func readCaseDataFromDatabase() {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")

        let query = fileNumberRef.whereField("document_id", isEqualTo: fileNumberDocumentID as Any)

        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let documentData: [String: Any] = document.data()
                    
                    self.readCaseData(from: documentData)
                }
            }
        }
        
    }
    

    
    //MARK: Read Client Data
    
    func readCaseData(from data: [String: Any]) {
        
        if let fileNumber = data["assigned_file_number"] {
            fileNumberTextField.text = fileNumber as? String
        }
        
        if let bond = data["bond"] {
            bondTextField.text = bond as? String
        }
        
        if let continuance = data["continuance"] {
            continuanceTextField.text = continuance as? String
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
        
        if let continuance = continuanceTextField.text {
            caseDataArray["continuance"] = continuance
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
    
    //MARK: UI Beautification Functions
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        caseInformationView.layer.masksToBounds = true
        caseInformationView.layer.cornerRadius = cornerRadiusValue
        
        billableHoursView.layer.masksToBounds = true
        billableHoursView.layer.cornerRadius = cornerRadiusValue
    }
}
