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
    @IBOutlet weak var dateAppointedLabel: UILabel!
    @IBOutlet weak var dateOfFirstClientInterviewLabel: UILabel!
    @IBOutlet weak var dateOfFinalDispositionLabel: UILabel!
    @IBOutlet weak var nameOfJudgeSettingFeeLabel: UILabel!
    
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
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let EDIT_CASE_DETAILS_SEGUE = "goToEditCaseDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItem = signOutButton

        addCornerRadiusToViews()
    }
    
    @IBAction func editCaseDetailsButton(_ sender: Any) {
        performSegue(withIdentifier: EDIT_CASE_DETAILS_SEGUE, sender: self)
    }
    
    // MARK: - Segues
    
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
    
    //MARK: - Bar Buttons
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
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
