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
    @IBOutlet weak var highestEducationLabel: UILabel!
    @IBOutlet weak var areaOfStudyLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
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
    
    let dbm = FirebaseFirestoreManager()
    let imageManager = FirebaseStorageManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let EDIT_CLIENT_DETAILS_SEGUE = "goToEditClientDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItem = signOutButton
                
        beautifyUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClientData()
    }
    
    //MARK: Bar Buttons
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editClientDetailsButton(_ sender: Any) {
        performSegue(withIdentifier: EDIT_CLIENT_DETAILS_SEGUE, sender: self)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditClientDetailsVC
        destinationVC.selectedClient = selectedClient
        destinationVC.selectedFileNumber = selectedFileNumber
    }
    
    //MARK: Load Client Data
    
    func loadClientData() {
        if let client = selectedClient {
            dbm.readClientDataFromDatabase(client) { (documentData, success) in
                if success {
                    self.readClientData(from: documentData)
                    
                    if let imagePath = documentData["image_path"] {
                        client.imagePath = imagePath as! String
                        self.imageManager.downloadClientImageFromStorage(client) { (imageData, success) in
                            if success {
                                print("Successfully read client image data")
                                self.clientPictureImageView.image = UIImage(data: imageData)
                            } else {
                                print("Problem reading client image data")
                            }
                        }
                    }
                } else {
                    print("Problem reading client data")
                }
            }
        }
    }
    
    //MARK: Read Client Data
    
    func readClientData(from data: [String: Any]) {
        
        var first = "", middle = "", last = ""
        
        if let firstName = data["first_name"] {
            first = firstName as! String
        }
        
        if let middleName = data["middle_name"] {
            middle = middleName as! String
        }
        
        if let lastName = data["last_name"] {
            last = lastName as! String
        }
        
        nameLabel.text = Utils.formatFullName(firstName: first, middleName: middle, lastName: last)

        if let age = data["age"] {
            ageLabel.text = age as? String
        }
        
        if let highestEducation = data["highest_education"] {
            highestEducationLabel.text = highestEducation as? String
        }
        
        if let areaOfStudy = data["area_of_study"] {
            areaOfStudyLabel.text = areaOfStudy as? String
        }
        
        if let phoneNumber = data["phone_number"] {
            phoneNumberLabel.text = phoneNumber as? String
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
        
        if let placeOfEmployment = data["place_of_employment"] {
            placeOfEmploymentLabel.text = placeOfEmployment as? String
        }
        
        if let role = data["role"] {
            roleLabel.text = role as? String
        }
        
        if let dataStarted = data["date_started"] {
            dateStartedLabel.text = dataStarted as? String
        }
        
        if let dateEnded = data["date_ended"] {
            dateEndedLabel.text = dateEnded as? String
        }
        
        if let incomeRange = data["income_range"] {
            incomeRangeLabel.text = incomeRange as? String
        }
        
        if let totalChildren = data["total_children"] {
            totalChildrenLabel.text = totalChildren as? String
        }
        
        if let totalOtherOccupants = data["total_other_occupants"] {
            totalOtherOccupantsLabel.text = totalOtherOccupants as? String
        }
    }
    
    //MARK: UI Beautification Functions
    
    func beautifyUI() {
        addCornerRadiusToViews()
        makeCircularView()
    }
    
    func makeCircularView() {
        clientPictureImageView.layer.masksToBounds = true
        clientPictureImageView.layer.cornerRadius = clientPictureImageView.bounds.width / 2
    }
    
    func addCornerRadiusToViews() {
        let cornerRadiusValue: CGFloat = 20.0
        
        clientInformationView.layer.masksToBounds = true
        clientInformationView.layer.cornerRadius = cornerRadiusValue
        
        workHistoryView.layer.masksToBounds = true
        workHistoryView.layer.cornerRadius = cornerRadiusValue
        
        householdResidentsView.layer.masksToBounds = true
        householdResidentsView.layer.cornerRadius = cornerRadiusValue
    }
}
