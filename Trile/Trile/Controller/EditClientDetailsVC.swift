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
    @IBOutlet weak var highestEducationTextField: UITextField!
    @IBOutlet weak var areaOfStudyTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
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
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCornerRadiusToViews()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readClientDataFromDatabase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveClientData()
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        print("CAMERA BUTTON CLICKED!")
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
    
    func readClientDataFromDatabase() {
        let clientRef = db.collection("users").document(uid).collection("clients")
        let clientDocumentID = selectedClient?.documentID
        let query = clientRef.whereField("document_id", isEqualTo: clientDocumentID as Any)
        
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
    
    //MARK: Read Client Data
    
    func readClientData(from data: [String: Any]) {
        if let name = data["name"] {
            nameTextField.text = name as? String
        }
        
        if let age = data["age"] {
            ageTextField.text = age as? String
        }
        
        if let highestEducation = data["highest_education"] {
            highestEducationTextField.text = highestEducation as? String
        }
        
        if let areaOfStudy = data["area_of_study"] {
            areaOfStudyTextField.text = areaOfStudy as? String
        }
        
        if let phoneNumber = data["phone_number"] {
            phoneNumberTextField.text = phoneNumber as? String
        }
        
        if let address = data["address"] {
            addressTextField.text = address as? String
        }
        
        if let city = data["city"] {
            cityTextField.text = city as? String
        }
        
        if let state = data["state"] {
            stateTextField.text = state as? String
        }
        
        if let zip = data["zip"] {
            zipTextField.text = zip as? String
        }
        
        if let placeOfEmployment = data["place_of_employment"] {
            placeOfEmploymentTextField.text = placeOfEmployment as? String
        }
        
        if let role = data["role"] {
            roleTextField.text = role as? String
        }
        
        if let dataStarted = data["date_started"] {
            dateStartedTextField.text = dataStarted as? String
        }
        
        if let dateEnded = data["date_ended"] {
            dateEndedTextField.text = dateEnded as? String
        }
        
        if let incomeRange = data["income_range"] {
            incomeRangeTextField.text = incomeRange as? String
        }
        
        if let totalChildren = data["total_children"] {
            totalChildrenTextField.text = totalChildren as? String
        }
        
        if let totalOtherOccupants = data["total_other_occupants"] {
            totalOtherOccupantsTextField.text = totalOtherOccupants as? String
        }
    }
    
    //MARK: Save Client Data
    
    func saveClientData() {
        var clientDataArray = [String: Any]()
        
        if let name = nameTextField.text {
            clientDataArray["name"] = name
        }
        
        if let age = ageTextField.text {
            clientDataArray["age"] = age
        }
        
        if let highestEducation = highestEducationTextField.text {
            clientDataArray["highest_education"] = highestEducation
        }
        
        if let areaOfStudy = areaOfStudyTextField.text {
            clientDataArray["area_of_study"] = areaOfStudy
        }
        
        if let phoneNumber = phoneNumberTextField.text {
            clientDataArray["phone_number"] = phoneNumber
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
            clientDataArray["place_of_employment"] = placeOfEmployment
        }
        
        if let role = roleTextField.text {
            clientDataArray["role"] = role
        }
        
        if let dateStarted = dateStartedTextField.text {
            clientDataArray["date_started"] = dateStarted
        }
        
        if let dateEnded = dateEndedTextField.text {
            clientDataArray["date_ended"] = dateEnded
        }
        
        if let incomeRange = incomeRangeTextField.text {
            clientDataArray["income_range"] = incomeRange
        }
        
        if let totalChildren = totalChildrenTextField.text {
            clientDataArray["total_children"] = totalChildren
        }
        
        if let totalOtherOccupants = totalOtherOccupantsTextField.text {
            clientDataArray["total_other_occupants"] = totalOtherOccupants
        }
        
        addClientDataToDatabase(clientDataArray)
    }
    
    //MARK: UI Beautification Functions
    
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
