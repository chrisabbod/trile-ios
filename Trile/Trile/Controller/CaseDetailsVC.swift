//
//  CaseDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/2/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class CaseDetailsVC: UIViewController {
    
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
        //        let destinationVC = segue.destination as! EditClientDetailsVC
        //        destinationVC.selectedClient = selectedClient
        //        destinationVC.selectedFileNumber = selectedFileNumber
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
        
//        clientPictureImageView.layer.masksToBounds = true
//        clientPictureImageView.layer.cornerRadius = clientPictureImageView.bounds.width / 2  //Create circular view
//        
//        clientInformationView.layer.masksToBounds = true
//        clientInformationView.layer.cornerRadius = cornerRadiusValue
//        
//        workHistoryView.layer.masksToBounds = true
//        workHistoryView.layer.cornerRadius = cornerRadiusValue
//        
//        householdResidentsView.layer.masksToBounds = true
//        householdResidentsView.layer.cornerRadius = cornerRadiusValue
    }
}
