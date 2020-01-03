//
//  DocumentsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/3/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class DocumentsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scanDocumentButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanDocument(_:)))
        
        navigationItem.rightBarButtonItem = scanDocumentButton
    }
    
    @objc
    func scanDocument(_ sender: Any) {
        print("BUTTON PRESSED")
    }
}
