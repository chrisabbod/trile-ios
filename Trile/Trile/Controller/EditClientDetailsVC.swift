//
//  EditClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/2/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditClientDetailsVC: UIViewController {
    
    @IBOutlet weak var clientPictureImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var placeOfEmploymentTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var dateStartedTextField: UITextField!
    @IBOutlet weak var dateEndedTextField: UITextField!
    @IBOutlet weak var incomeRangeTextField: UITextField!
    
    @IBOutlet weak var totalChildrenTextField: UITextField!
    @IBOutlet weak var totalOtherOccupantsTextField: UITextField!
    
    @IBOutlet weak var clientInformationView: UIView!
    @IBOutlet weak var workHistoryView: UIView!
    @IBOutlet weak var householdResidentsView: UIView!
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid

    var selectedClient: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCornerRadiusToViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveClientData()
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        print("CAMERA BUTTON CLICKED!")
    }
    
    func saveClientData() {
        var clientDataArray = [String: Any]()
        
        if let name = nameTextField.text {
            clientDataArray["name"] = name
        }
        
        if let age = ageTextField.text {
            clientDataArray["age"] = age
        }
        
        if let address = addressTextField.text {
            clientDataArray["address"] = address
        }
        
        if let city = cityTextField.text {
            clientDataArray["city"] = city
        }
        
        if let state = stateTextField.text {
            clientDataArray["state"] = state
        }
        
        if let zip = zipTextField.text {
            clientDataArray["zip"] = zip
        }
        
        if let placeOfEmployment = placeOfEmploymentTextField.text {
            clientDataArray["placeOfEmployment"] = placeOfEmployment
        }
        
        if let role = roleTextField.text {
            clientDataArray["role"] = role
        }
        
        if let dateStarted = dateStartedTextField.text {
            clientDataArray["dateStarted"] = dateStarted
        }
        
        if let dateEnded = dateEndedTextField.text {
            clientDataArray["dateEnded"] = dateEnded
        }
        
        if let incomeRange = incomeRangeTextField.text {
            clientDataArray["incomeRange"] = incomeRange
        }
        
        if let totalChildren = totalChildrenTextField.text {
            clientDataArray["totalChildren"] = totalChildren
        }
        
        if let totalOtherOccupants = totalOtherOccupantsTextField.text {
            clientDataArray["totalOtherOccupants"] = totalOtherOccupants
        }
        
        addClientDataToDatabase(clientDataArray)
    }
    
    //MARK: - Database CRUD Functions
    
    func addClientDataToDatabase(_ clientData: [String: Any]) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID") }

        clientRef.document(clientDocumentID).setData(clientData, merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
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
