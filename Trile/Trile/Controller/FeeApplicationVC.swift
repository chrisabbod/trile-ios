//
//  FeeApplicationVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/7/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class FeeApplicationVC: UIViewController {
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Client: \(selectedClient?.name)")
        print("File Number: \(selectedFileNumber?.assignedFileNumber)")
    }
    
}
