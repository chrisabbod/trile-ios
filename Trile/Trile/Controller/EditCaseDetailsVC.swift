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
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCornerRadiusToViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCaseData()
    }

    //MARK: - Database CRUD Functions
    
    func addCaseDataToDatabase(_ caseData: [String: Any]) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}

        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        fileNumberRef.document(fileNumberDocumentID).setData(caseData, merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    //MARK: - Save Case Data
    
    func saveCaseData() {
        var caseDataArray = [String: Any]()
        
        if let fileNumber = fileNumberTextField.text {
            caseDataArray["file_number"] = fileNumber
        }
        
        addCaseDataToDatabase(caseDataArray)
    }
    
    //MARK: - UI Beautification Functions
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        caseInformationView.layer.masksToBounds = true
        caseInformationView.layer.cornerRadius = cornerRadiusValue
        
        billableHoursView.layer.masksToBounds = true
        billableHoursView.layer.cornerRadius = cornerRadiusValue
    }
}
