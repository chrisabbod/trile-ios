//
//  PlaceholderVC.swift
//  Trile
//
//  Created by Chris Abbod on 2/17/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class PlaceholderVC: UIViewController {

    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var placeholderText: UILabel!
    
    let ADD_CLIENT = "add_client"
    let ADD_FILE_NUMBER = "add_file_number"
    let CHOOSE_CLIENT = "choose_client"
    let CHOOSE_FILE_NUMBER = "choose_file_number"
    
    let ADD_A_CLIENT = "Add A Client"
    let ADD_A_FILE_NUMBER = "Add A File Number"
    let CHOOSE_A_CLIENT = "Choose A Client"
    let CHOOSE_A_FILE_NUMBER = "Choose A File Number"
    
    //Determine which screen will be displayed
    var addClient: Bool = false
    var chooseClient: Bool = false
    var addFileNumber: Bool = false
    var chooseFileNumber: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if addClient == true {
            print("SHOW ADD CLIENT SCREEN")
            placeholderImage.image = UIImage(named: ADD_CLIENT)
            placeholderText.text = ADD_A_CLIENT
        } else if chooseClient == true {
            print("SHOW CHOOSE CLIENT SCREEN")
            placeholderImage.image = UIImage(named: CHOOSE_CLIENT)
            placeholderText.text = CHOOSE_A_CLIENT
        } else if addFileNumber == true {
            print("SHOW ADD FILE NUMBER SCREEN")
            placeholderImage.image = UIImage(named: ADD_FILE_NUMBER)
            placeholderText.text = ADD_A_FILE_NUMBER
        } else if chooseFileNumber == true {
            print("SHOW CHOOSE FILE NUMBER SCREEN")
            placeholderImage.image = UIImage(named: CHOOSE_FILE_NUMBER)
            placeholderText.text = CHOOSE_A_FILE_NUMBER
        } else {
            print("Error determining which image to display")
        }
    }
}
