//
//  ClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/1/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let EDIT_CLIENT_DETAILS_SEGUE = "goToEditClientDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        
        self.navigationItem.rightBarButtonItem = signOutButton
        
        readClientDataFromDatabase()
        
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
    
    //MARK: - Database CRUD Functions
    
    func readClientDataFromDatabase() {
        let clientRef = db.collection("users").document(uid).collection("clients")
        let clientDocumentID = selectedClient?.documentID
        let query = clientRef.whereField("documentID", isEqualTo: clientDocumentID as Any)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let documentData: [String: Any] = document.data()
                    
                    self.readClientData(from: documentData)
                }
            }
        }
        
    }
    
    //MARK: - Read Client Data
    
    func readClientData(from data: [String: Any]) {
        if let name = data["name"] {
            nameLabel.text = name as? String
        }
        
        if let age = data["age"] {
            ageLabel.text = age as? String
        }
        
        if let address = data["address"] {
            addressLabel.text = address as? String
        }
        
        if let city = data["city"] {
            cityLabel.text = city as? String
        }
        
        if let state = data["state"] {
            stateLabel.text = state as? String
        }
        
        if let zip = data["zip"] {
            zipLabel.text = zip as? String
        }
        
        if let placeOfEmployment = data["placeOfEmployment"] {
            placeOfEmploymentLabel.text = placeOfEmployment as? String
        }
        
        if let role = data["role"] {
            roleLabel.text = role as? String
        }
        
        if let dataStarted = data["dateStarted"] {
            dateStartedLabel.text = dataStarted as? String
        }
        
        if let dateEnded = data["dateEnded"] {
            dateEndedLabel.text = dateEnded as? String
        }
        
        if let incomeRange = data["incomeRange"] {
            incomeRangeLabel.text = incomeRange as? String
        }
        
        if let totalChildren = data["totalChildren"] {
            totalChildrenLabel.text = totalChildren as? String
        }
        
        if let totalOtherOccupants = data["totalOtherOccupants"] {
            totalOtherOccupantsLabel.text = totalOtherOccupants as? String
        }
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
