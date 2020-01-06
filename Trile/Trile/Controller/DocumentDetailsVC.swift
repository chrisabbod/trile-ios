//
//  DocumentDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/5/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class DocumentDetailsVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet var documentScrollView: UIScrollView!
    @IBOutlet weak var documentImageView: UIImageView!
    
    var selectedDocument: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        documentScrollView.delegate = self
        
        self.documentScrollView.minimumZoomScale = 1.0;
        self.documentScrollView.maximumZoomScale = 5.0;
        
        if let imageData = selectedDocument?.imageData {
            documentImageView.image = UIImage(data: imageData)
        }
    }
}
