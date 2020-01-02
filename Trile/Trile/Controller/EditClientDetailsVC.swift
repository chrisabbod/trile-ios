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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCircularClientImage()
    }
    
    @IBAction func camerButton(_ sender: Any) {
        print("CLICKED CAMERA")
    }
    
    func createCircularClientImage() {
        clientPictureImageView.layer.masksToBounds = true
        clientPictureImageView.layer.cornerRadius = clientPictureImageView.bounds.width / 2
    }
}
