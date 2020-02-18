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
    
    var client: Bool = true //Check if user is on client or file number screen
    var hasItems: Bool = false  //Check if there are any clients/file numbers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if client == true && hasItems == true {
//            print("SHOW CHOOSE CLIENT SCREEN")
//        } else if client == true && hasItems == false {
//            print("SHOW ADD CLIENT SCREEN")
//            placeholderImage.image = UIImage(named: ADD_CLIENT)
//            placeholderText.text = "Add A Client"
//        } else if client == false && hasItems == true {
//            print("SHOW CHOOSE FILE NUMBER SCREEN")
//        } else if client == false && hasItems == false {
//            print("SHOW ADD FILE NUMBER SCREEN")
//        }
    }
}
