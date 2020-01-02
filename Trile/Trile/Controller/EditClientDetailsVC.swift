//
//  EditClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/2/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editViewCornerRadius()
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        print("CAMERA BUTTON CLICKED!")
    }
    
    //MARK: - UI Beautification Functions

    func editViewCornerRadius() {
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
