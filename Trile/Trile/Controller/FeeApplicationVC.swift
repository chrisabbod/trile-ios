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
    var user = User()
        
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
                            
                            self.dbm.readUserDataFromDatabase { (returnedUserData, success) in
                                if success {
                                    self.readUserData(from: returnedUserData)
                                    self.setFieldsInPDF()
                                }
                            }
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
                        case "OtherTrafficCbx":
                            if fileNumber.offenseTrafficType == "Traffic" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "MisdemeanorOtherTraffic":
                            if fileNumber.offenseTrafficType == "Traffic" {
                                annotation.setValue(fileNumber.offenseClass, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "CriminalContemptCbx":
                            if fileNumber.offense == "Criminal Contempt" {
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
                        case "FTA/OFAWithoutDismissalCbx":
                            if fileNumber.disposition == "FTA/OFA Without Dismissal" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "DeferredDivertedCbx":
                            if fileNumber.disposition == "Deferred/Diverted" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "HeldInCriminalContemptCbx":
                            if fileNumber.disposition == "Held In Criminal Contempt" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "NoProbableCauseCbx":
                            if fileNumber.disposition == "No Probable Cause" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "AttorneyWithdrewCbx":
                            if fileNumber.disposition == "Attorney Withdrew" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "DispositionNoneInterimFeeCbx":
                            if fileNumber.disposition == "None (Interim Fee)" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "OtherDispositionCbx":
                            if fileNumber.disposition == "Other" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        //MARK: Judgment/Sentencing
                        case "ActiveSentenceCbx":
                            if fileNumber.judgmentAndSentencing == "Active Sentence" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "ActiveLengthOfSentence":
                            if fileNumber.judgmentAndSentencing == "Active Sentence" {
                                let sentenceMonthsAndDays = ("\(fileNumber.sentenceMonths) Months \(fileNumber.sentenceDays) Days")
                                annotation.setValue(sentenceMonthsAndDays, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "SplitSentenceCbx":
                            if fileNumber.judgmentAndSentencing == "Split Sentence" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "SupervisedProbationCbx":
                            if fileNumber.judgmentAndSentencing == "Supervised Probation" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "UnsupervisedProbationCbx":
                            if fileNumber.judgmentAndSentencing == "Unsupervised Probation" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "ProbationTerminatedCbx":
                            if fileNumber.judgmentAndSentencing == "Probation Terminated" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "PJCCbx":
                            if fileNumber.judgmentAndSentencing == "PJC" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "FinesAndCostsOnlyCbx":
                            if fileNumber.judgmentAndSentencing == "Fines and Costs Only" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "NoneAcquittedDismissedCbx":
                            if fileNumber.judgmentAndSentencing == "None (Acquitted/Dismissed)" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "NoneDeferredDivertedCbx":
                            if fileNumber.judgmentAndSentencing == "None (Deferred/Diverted)" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "NoneAttorneyWithdrewCbx":
                            if fileNumber.judgmentAndSentencing == "None (Attorney Withdrew)" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "JudgmentSentencingNoneInterimFeeCbx":
                            if fileNumber.judgmentAndSentencing == "None (Interim Fee)" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "JudgmentSentencingOtherCbx":
                            if fileNumber.judgmentAndSentencing == "Other" {
                                annotation.buttonWidgetState = .onState
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        //MARK: Dates
                        case "DispDate":
                            annotation.setValue(fileNumber.dateOfFinalDisposition, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "StartDate":
                            annotation.setValue(fileNumber.dateAppointed, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "EndDate":
                            annotation.setValue(fileNumber.dateOfFinalDisposition, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "FristSubstantiveClientInterviewDate":
                            annotation.setValue(fileNumber.dateOfFirstClientInterview, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "PriorTotalFeesAndExpensesAllowed":
                            annotation.setValue("0", forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        //MARK: Judge
                        case "JudgeSettingFeeName":
                            annotation.setValue(fileNumber.nameOfJudgeSettingFee, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        //MARK: Billable Hours
                        case "TimeInCourt":
                            let timeInCourt = ("\(fileNumber.timeInCourtHours) Hours \(fileNumber.timeInCourtMinutes) Minutes")
                            annotation.setValue(timeInCourt, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "TimeInCourtWaiting":
                            let timeInCourtWaiting = ("\(fileNumber.timeInCourtWaitingHours) Hours \(fileNumber.timeInCourtWaitingMinutes) Minutes")
                            annotation.setValue(timeInCourtWaiting, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "TimeOutOfCourt":
                            let timeOutOfCourt = ("\(fileNumber.timeOutOfCourtHours) Hours \(fileNumber.timeOutOfCourtMinutes) Minutes")
                            annotation.setValue(timeOutOfCourt, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "TotalTimeClaim":
                            let totalTime = CalculationManager.calculatedTotalTimeClaimed(fileNumber)
                            if let totalHours = totalTime["total_hours"], let totalMinutes = totalTime["total_minutes"] {
                                let totalTimeClaimed = "\(totalHours) Hours \(totalMinutes) Minutes"
                                
                                annotation.setValue(totalTimeClaimed, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        //MARK: Expenses
                        case "TravelCosts":
                            annotation.setValue(fileNumber.travel, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "CopyCosts":
                            annotation.setValue(fileNumber.copying, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "OtherCosts":
                            annotation.setValue(fileNumber.other, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "TotalExpenses":
                            let totalExpenses = CalculationManager.calculateTotalExpenses(fileNumber)
                            annotation.setValue(totalExpenses, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        //MARK: User Info
                        case "NameAppl":
                            let firstName = user.firstName
                            let lastName = user.lastName
                            let fullName = firstName + " " + lastName
                            
                            annotation.setValue(fullName, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "Payee":
                            if user.soloPractitioner {
                                let payee = "Same"

                                annotation.setValue(payee, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            } else {
                                let payee = user.firmName
                                
                                annotation.setValue(payee, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TaxpayerIDNo":
                            if !user.soloPractitioner {
                                annotation.setValue(user.taxpayerID, forAnnotationKey: .widgetValue)
                                page.removeAnnotation(annotation)
                                page.addAnnotation(annotation)
                            }
                        case "TeleNo":
                            print("WILL IMPLEMENT SOON")
                        case "EmailAddress":
                            annotation.setValue(user.email, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "ApplicantStAddr":
                            annotation.setValue(user.address, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "ApplicantCity":
                            annotation.setValue(user.city, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "ApplicantState":
                            annotation.setValue(user.state, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "ApplicantZip":
                            annotation.setValue(user.zip, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        case "ApplicantSignatureDate":
                            let currentDate = DateManager.getCurrentDate()
                            
                            annotation.setValue(currentDate, forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
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

    }
    
    //MARK: Read Case Data
    
    func readCaseData(from data: [String: Any]) {
        guard let fileNumber = selectedFileNumber else { return print("Could not get file number information")}
        
        if let assignedFileNumber = data["assigned_file_number"] {
            fileNumber.assignedFileNumber = assignedFileNumber as! String
        }

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
        
        if let judgmentAndSentencing = data["judgment_and_sentencing"] {
            fileNumber.judgmentAndSentencing = judgmentAndSentencing as! String
        }
        
        if let sentenceMonths = data["sentence_months"] {
            fileNumber.sentenceMonths = sentenceMonths as! String
        }
        
        if let sentenceDays = data["sentence_days"] {
            fileNumber.sentenceDays = sentenceDays as! String
        }
        
        if let county = data["county"] {
            fileNumber.county = county as! String
        }
        
        if let nameOfJudgeSettingFee = data["name_of_judge_setting_fee"] {
            fileNumber.nameOfJudgeSettingFee = nameOfJudgeSettingFee as! String
        }
        
        if let dateAppointed = data["date_appointed"] {
            fileNumber.dateAppointed = dateAppointed as! String
        }
        
        if let dateOfFirstClientInterview = data["date_of_first_client_interview"] {
            fileNumber.dateOfFirstClientInterview = dateOfFirstClientInterview as! String
        }
        
        if let dateOfFinalDisposition = data["date_of_final_disposition"] {
            fileNumber.dateOfFinalDisposition = dateOfFinalDisposition as! String
        }
        
        if let timeInCourtHours = data["time_in_court_hours"] {
            fileNumber.timeInCourtHours = timeInCourtHours as! String
        }
        
        if let timeInCourtMinutes = data["time_in_court_minutes"] {
            fileNumber.timeInCourtMinutes = timeInCourtMinutes as! String
        }
        
        if let timeInCourtWaitingHours = data["time_in_court_waiting_hours"] {
            fileNumber.timeInCourtWaitingHours = timeInCourtWaitingHours as! String
        }
        
        if let timeInCourtWaitingMinutes = data["time_in_court_waiting_minutes"] {
            fileNumber.timeInCourtWaitingMinutes = timeInCourtWaitingMinutes as! String
        }
        
        if let timeOutOfCourtHours = data["time_out_of_court_hours"] {
            fileNumber.timeOutOfCourtHours = timeOutOfCourtHours as! String
        }
        
        if let timeOutOfCourtMinutes = data["time_out_of_court_minutes"] {
            fileNumber.timeOutOfCourtMinutes = timeOutOfCourtMinutes as! String
        }
        
        if let travelExpenses = data["travel_expenses"] {
            fileNumber.travel = travelExpenses as! String
        }
        
        if let copyingExpenses = data["copying_expenses"] {
            fileNumber.copying = copyingExpenses as! String
        }
        
        if let otherExpenses = data["other_expenses"] {
            fileNumber.other = otherExpenses as! String
        }
    }
    
    
    //MARK: Read User Data
    
    func readUserData(from data: [String: Any]) {
        
        if let soloPractitioner = data["solo_practitioner"] {
            user.soloPractitioner = soloPractitioner as! Bool
        }
        
        if let email = data["email"] {
            user.email = email as! String
        }
        
        if let firstName = data["first_name"] {
            user.firstName = firstName as! String
        }
        
        if let lastName = data["last_name"] {
            user.lastName = lastName as! String
        }
        
        if let address = data["address"] {
            user.address = address as! String
        }
        
        if let city = data["city"] {
            user.city = city as! String
        }
        
        if let state = data["state"] {
            user.state = state as! String
        }
        
        if let zip = data["zip"] {
            user.zip = zip as! String
        }
        
        if let firmName = data["firm_name"] {
            user.firmName = firmName as! String
        }
        
        if let taxpayerID = data["taxpayer_id"] {
            user.taxpayerID = taxpayerID as! String
        }
    }
}
