//
//  CaseDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/2/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CaseDetailsVC: UIViewController {
    
    @IBOutlet weak var fileNumberLabel: UILabel!
    @IBOutlet weak var bondLabel: UILabel!
    @IBOutlet weak var continuanceLabel: UILabel!
    @IBOutlet weak var desiredOutcomeLabel: UILabel!
    @IBOutlet weak var offenseLabel: UILabel!
    @IBOutlet weak var offenseClassLabel: UILabel!
    @IBOutlet weak var dispositionLabel: UILabel!
    @IBOutlet weak var judgmentAndSentencingLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var nameOfJudgeSettingFeeLabel: UILabel!
    @IBOutlet weak var dateAppointedLabel: UILabel!
    @IBOutlet weak var dateOfFirstClientInterviewLabel: UILabel!
    @IBOutlet weak var dateOfFinalDispositionLabel: UILabel!
    
    @IBOutlet weak var timeInCourtHoursLabel: UILabel!
    @IBOutlet weak var timeInCourtMinutesLabel: UILabel!
    @IBOutlet weak var timeInCourtWaitingHoursLabel: UILabel!
    @IBOutlet weak var timeInCourtWaitingMinutesLabel: UILabel!
    @IBOutlet weak var timeOutOfCourtHoursLabel: UILabel!
    @IBOutlet weak var timeOutOfCourtMinutesLabel: UILabel!
    
    @IBOutlet weak var caseInformationView: UIView!
    @IBOutlet weak var billableHoursView: UIView!
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let EDIT_CASE_DETAILS_SEGUE = "goToEditCaseDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItem = signOutButton
        
        addCornerRadiusToViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.readCaseDataFromDatabase(client, fileNumber) { (caseData, success) in
                self.readCaseData(from: caseData)
            }
        }
    }
    
    //MARK: Bar Buttons
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
    }
    
    @IBAction func editCaseDetailsButton(_ sender: Any) {
        performSegue(withIdentifier: EDIT_CASE_DETAILS_SEGUE, sender: self)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditCaseDetailsVC
        destinationVC.selectedClient = selectedClient
        destinationVC.selectedFileNumber = selectedFileNumber
    }
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
    
    //MARK: Read Case Data
    
    func readCaseData(from data: [String: Any]) {
        
        if let fileNumber = data["assigned_file_number"] {
            fileNumberLabel.text = fileNumber as? String
        }
        
        if let bond = data["bond"] {
            bondLabel.text = bond as? String
        }
        
        if let continuances = data["continuances"] {
            continuanceLabel.text = continuances as? String
        }
        
        if let desiredOutcome = data["desired_outcome"] {
            desiredOutcomeLabel.text = desiredOutcome as? String
        }
        
        if let offense = data["offense"] {
            offenseLabel.text = offense as? String
        }
        
        if let offenseClass = data["offense_class"] {
            offenseClassLabel.text = offenseClass as? String
        }
        
        if let disposition = data["disposition"] {
            dispositionLabel.text = disposition as? String
        }
        
        if let judgmentAndSentencing = data["judgment_and_sentencing"] {
            judgmentAndSentencingLabel.text = judgmentAndSentencing as? String
        }
        
        if let county = data["county"] {
            countyLabel.text = county as? String
        }
        
        if let dateAppointed = data["date_appointed"] {
            dateAppointedLabel.text = dateAppointed as? String
        }
        
        if let dateOfFirstClientInterview = data["date_of_first_client_interview"] {
            dateOfFirstClientInterviewLabel.text = dateOfFirstClientInterview as? String
        }
        
        if let dateOfFinalDisposition = data["date_of_final_disposition"] {
            dateOfFinalDispositionLabel.text = dateOfFinalDisposition as? String
        }
        
        if let nameOfJudgeSettingFee = data["name_of_judge_setting_fee"] {
            nameOfJudgeSettingFeeLabel.text = nameOfJudgeSettingFee as? String
        }
        
        if let timeInCourtHours = data["time_in_court_hours"] {
            timeInCourtHoursLabel.text = timeInCourtHours as? String
        }
        
        if let timeInCourtMinutes = data["time_in_court_minutes"] {
            timeInCourtMinutesLabel.text = timeInCourtMinutes as? String
        }
        
        if let timeInCourtWaitingHours = data["time_in_court_waiting_hours"] {
            timeInCourtWaitingHoursLabel.text = timeInCourtWaitingHours as? String
        }
        
        if let timeInCourtWaitingMinutes = data["time_in_court_waiting_minutes"] {
            timeInCourtWaitingMinutesLabel.text = timeInCourtWaitingMinutes as? String
        }
        
        if let timeOutOfCourtHours = data["time_out_of_court_hours"] {
            timeOutOfCourtHoursLabel.text = timeOutOfCourtHours as? String
        }
        
        if let timeOutOfCourtMinutes = data["time_out_of_court_minutes"] {
            timeOutOfCourtMinutesLabel.text = timeOutOfCourtMinutes as? String
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
