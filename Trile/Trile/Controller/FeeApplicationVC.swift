//
//  FeeApplicationVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/7/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PDFKit

class FeeApplicationVC: UIViewController {
    
    let fileURL: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/trile-6bbdc.appspot.com/o/Fee%20Application%2FFee%20Application.pdf?alt=media&token=f4702080-ce8f-4827-9011-8e7e92d20213")!
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    var caseData = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let printButton = UIBarButtonItem(title: "Print", style: .done, target: self, action: #selector(printPDF(_:)))
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItems = [signOutButton, printButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            
            dbm.readClientDataFromDatabase(client) { (returnedClientData, success) in
                if success {
                    self.readClientData(from: returnedClientData)
                    self.dbm.readCaseDataFromDatabase(client, fileNumber) { (returnedCaseData, success) in
                        if success {
                            self.readCaseData(from: returnedCaseData)
                            self.setFieldsInPDF()
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK: Bar Buttons
    
    @objc
    func printPDF(_ sender: UIBarButtonItem) {
        print("Print button wired up")
    }
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: PDF Functions
    
    func showPDF() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if let document = PDFDocument(url: fileURL) {
            pdfView.document = document
        }
    }
    
    func showModifiedPDF(fileNumber: FileNumber) {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let pdfData = fileNumber.pdfData
        if let document = PDFDocument(data: pdfData) {
            pdfView.document = document
        }
    }
    
    func setFieldsInPDF() {
        guard let client = selectedClient else { return print("Could not get client information")}
        guard let fileNumber = selectedFileNumber else { return print("Could not get file number information")}
        
        if let document = PDFDocument(url: fileURL) {
            for index in 0..<document.pageCount{
                if let page = document.page(at: index){
                    let annotations = page.annotations
                    
                    for annotation in annotations {
                        let field = annotation.fieldName
                        
                        switch field {
                        case "FileNo":
                            annotation.setValue(fileNumber.assignedFileNumber, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "District":
                            annotation.buttonWidgetState = .onState
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "County":
                            annotation.setValue(fileNumber.county, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "NameAddrAppl":
                            let nameAndAdress = ("\(client.name)\n\(client.address)\n\(client.state) \(client.zip)")
                            annotation.setValue(nameAndAdress, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "DateAttorneyAppointed":
                            annotation.setValue(fileNumber.dateAppointed, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "AssignedCounselCbx":
                            annotation.buttonWidgetState = .onState
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                            //MARK: Original Charge
                        case "FelonyOffenseCbx":
                            if fileNumber.offenseCategory == "Felony" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "FelonyOffenseClass":
                            if fileNumber.offenseCategory == "Felony" {
                                annotation.setValue(fileNumber.offenseClass, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "NameOfOffense1":
                            if fileNumber.offenseCategory == "Felony" {
                                annotation.setValue(fileNumber.offense, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "MisdemeanorOffenseNonTrafficCbx":
                            if fileNumber.offenseCategory == "Misdemeanor" && fileNumber.offenseTrafficType == "Non Traffic" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "MisdemeanorNonTrafficClass":
                            if fileNumber.offenseCategory == "Misdemeanor" && fileNumber.offenseTrafficType == "Non Traffic" {
                                annotation.setValue(fileNumber.offenseClass, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "MisdemeanorProbationViolationCbx":
                            if fileNumber.offenseCategory == "Misdemeanor Probation Violation" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                            //MARK: Disposition
                        case "GuiltyPleaBeforeTrialOriginalChargeCbx":
                            if fileNumber.disposition == "Guilty Plea Before Trial: Most Serious Original Charge" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "GuiltyPleaBeforeTrialOtherOffenseCbx":
                            if fileNumber.disposition == "Guilty Plea Before Trial: Other Offense" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "GuiltyPleaBeforeTrialOtherOffense":
                            if fileNumber.disposition == "Guilty Plea Before Trial: Other Offense" {
                                annotation.setValue(fileNumber.otherOffense, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "GuiltyPleaDuringTrialCbx":
                            if fileNumber.disposition == "Guilty Plea During Trial: Other Offense" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "GuiltyPleaDuringTrial":
                            if fileNumber.disposition == "Guilty Plea During Trial: Other Offense" {
                                annotation.setValue(fileNumber.otherOffense, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TrialOriginalChargeCbx":
                            if fileNumber.disposition == "Trial: Guilty Most Serious Original Charge" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TrialOtherOffenseCbx":
                            if fileNumber.disposition == "Trial: Guilty Other Offense" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TrialOtherOffenseNameOfOffense":
                            if fileNumber.disposition == "Trial: Guilty Other Offense" {
                                annotation.setValue(fileNumber.otherOffense, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TrialAcquittedCbx":
                            if fileNumber.disposition == "Trial: Acquitted" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "ProbationViolationFoundCbx":
                            if fileNumber.disposition == "Probation Violation Found" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "DismissedWithLeaveCbx":
                            if fileNumber.disposition == "Dismissed With Leave" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "DismissedWithoutLeaveCbx":
                            if fileNumber.disposition == "Dismissed Without Leave" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        default:
                            print("Could not modify PDF")
                        }
                    }
                }
            }
            
            if let client = selectedClient, let fileNumber = selectedFileNumber {
                dbm.addPDFToDatabase(client, fileNumber, PDF: document)
                dbm.readPDFDataFromDatabase(client, fileNumber) { (returnedFileNumber, success) in
                    if success {
                        self.selectedFileNumber = returnedFileNumber
                        self.showModifiedPDF(fileNumber: returnedFileNumber)
                    }
                }
            }
        }
    }
    
    //MARK: Read Client Data
    
    func readClientData(from data: [String: Any]) {
        guard let client = selectedClient else { return print("Could not get client information")}
        
        if let name = data["name"] {
            client.name = name as! String
        }
        //
        //        if let age = data["age"] {
        //            ageLabel.text = age as? String
        //        }
        //
        //        if let highestEducation = data["highest_education"] {
        //            highestEducationLabel.text = highestEducation as? String
        //        }
        //
        //        if let areaOfStudy = data["area_of_study"] {
        //            areaOfStudyLabel.text = areaOfStudy as? String
        //        }
        //
        //        if let phoneNumber = data["phone_number"] {
        //            phoneNumberLabel.text = phoneNumber as? String
        //        }
        //
                if let address = data["address"] {
                    client.address = address as! String
                }
        
                if let city = data["city"] {
                    client.city = city as! String
                }
        
                if let state = data["state"] {
                    client.state = state as! String
                }
        
                if let zip = data["zip"] {
                    client.zip = zip as! String
                }
        //
        //        if let placeOfEmployment = data["place_of_employment"] {
        //            placeOfEmploymentLabel.text = placeOfEmployment as? String
        //        }
        //
        //        if let role = data["role"] {
        //            roleLabel.text = role as? String
        //        }
        //
        //        if let dataStarted = data["date_started"] {
        //            dateStartedLabel.text = dataStarted as? String
        //        }
        //
        //        if let dateEnded = data["date_ended"] {
        //            dateEndedLabel.text = dateEnded as? String
        //        }
        //
        //        if let incomeRange = data["income_range"] {
        //            incomeRangeLabel.text = incomeRange as? String
        //        }
        //
        //        if let totalChildren = data["total_children"] {
        //            totalChildrenLabel.text = totalChildren as? String
        //        }
        //
        //        if let totalOtherOccupants = data["total_other_occupants"] {
        //            totalOtherOccupantsLabel.text = totalOtherOccupants as? String
        //        }
    }
    
    //MARK: Read Case Data
    
    func readCaseData(from data: [String: Any]) {
        guard let fileNumber = selectedFileNumber else { return print("Could not get file number information")}
        
        if let assignedFileNumber = data["assigned_file_number"] {
            fileNumber.assignedFileNumber = assignedFileNumber as! String
        }
        
        //        if let bond = data["bond"] {
        //            bondTextField.text = bond as? String
        //        }
        //
        //        if let continuances = data["continuances"] {
        //            continuancesTextField.text = continuances as? String
        //        }
        //
        //        if let desiredOutcome = data["desired_outcome"] {
        //            desiredOutcomeTextField.text = desiredOutcome as? String
        //        }
        
        if let offense = data["offense"] {
            fileNumber.offense = offense as! String
        }
        
        if let offenseCategory = data["offense_category"] {
            fileNumber.offenseCategory = offenseCategory as! String
        }
        
        if let offenseClass = data["offense_class"] {
            fileNumber.offenseClass = offenseClass as! String
        }
        
        if let offenseTrafficType = data["offense_traffic_type"] {
            fileNumber.offenseTrafficType = offenseTrafficType as! String
        }
        
        if let disposition = data["disposition"] {
            fileNumber.disposition = disposition as! String
        }
        
        if let otherOffense = data["other_offense"] {
            fileNumber.otherOffense = otherOffense as! String
        }
        
        //        if let judgmentAndSentencing = data["judgment_and_sentencing"] {
        //            judgmentAndSentencingTextField.text = judgmentAndSentencing as? String
        //        }
        //
        if let county = data["county"] {
            fileNumber.county = county as! String
        }
        //
        //        if let nameOfJudgeSettingFee = data["name_of_judge_setting_fee"] {
        //            nameOfJudgeSettingFeeTextField.text = nameOfJudgeSettingFee as? String
        //        }
        
        if let dateAppointed = data["date_appointed"] {
            fileNumber.dateAppointed = dateAppointed as! String
        }
        
        //        if let dateOfFirstClientInterview = data["date_of_first_client_interview"] {
        //            dateOfFirstClientInterviewTextField.text = dateOfFirstClientInterview as? String
        //        }
        //
        //        if let dateOfFinalDisposition = data["date_of_final_disposition"] {
        //            dateOfFinalDispositionTextField.text = dateOfFinalDisposition as? String
        //        }
        //
        //        if let timeInCourtHours = data["time_in_court_hours"] {
        //            timeInCourtHoursTextField.text = timeInCourtHours as? String
        //        }
        //
        //        if let timeInCourtMinutes = data["time_in_court_minutes"] {
        //            timeInCourtMinutesTextField.text = timeInCourtMinutes as? String
        //        }
        //
        //        if let timeInCourtWaitingHours = data["time_in_court_waiting_hours"] {
        //            timeInCourtWaitingHoursTextField.text = timeInCourtWaitingHours as? String
        //        }
        //
        //        if let timeInCourtWaitingMinutes = data["time_in_court_waiting_minutes"] {
        //            timeInCourtWaitingMinutesTextField.text = timeInCourtWaitingMinutes as? String
        //        }
        //
        //        if let timeOutOfCourtHours = data["time_out_of_court_hours"] {
        //            timeOutOfCourtHoursTextField.text = timeOutOfCourtHours as? String
        //        }
        //
        //        if let timeOutOfCourtMinutes = data["time_out_of_court_minutes"] {
        //            timeOutOfCourtMinutesTextField.text = timeOutOfCourtMinutes as? String
        //        }
    }
}
