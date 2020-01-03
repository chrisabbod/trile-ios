//
//  ClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/1/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class ClientDetailsVC: UIViewController {
    
    @IBOutlet weak var clientPictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    @IBOutlet weak var placeOfEmploymentLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var dateStartedLabel: UILabel!
    @IBOutlet weak var dateEndedLabel: UILabel!
    @IBOutlet weak var incomeRangeLabel: UILabel!
    
    @IBOutlet weak var totalChildrenLabel: UILabel!
    @IBOutlet weak var totalOtherOccupantsLabel: UILabel!
    
    @IBOutlet weak var clientInformationView: UIView!
    @IBOutlet weak var workHistoryView: UIView!
    @IBOutlet weak var householdResidentsView: UIView!
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let EDIT_CLIENT_DETAILS_SEGUE = "goToEditClientDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        
        self.navigationItem.rightBarButtonItem = signOutButton
        
        addCornerRadiusToViews()
    }
    
    @IBAction func editClientDetailsButton(_ sender: Any) {
        performSegue(withIdentifier: EDIT_CLIENT_DETAILS_SEGUE, sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditClientDetailsVC
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
        
        clientPictureImageView.layer.masksToBounds = true
        clientPictureImageView.layer.cornerRadius = clientPictureImageView.bounds.width / 2  //Create circular view
        
        clientInformationView.layer.masksToBounds = true
        clientInformationView.layer.cornerRadius = cornerRadiusValue
        
        workHistoryView.layer.masksToBounds = true
        workHistoryView.layer.cornerRadius = cornerRadiusValue
        
        householdResidentsView.layer.masksToBounds = true
        householdResidentsView.layer.cornerRadius = cornerRadiusValue
    }
    
}
