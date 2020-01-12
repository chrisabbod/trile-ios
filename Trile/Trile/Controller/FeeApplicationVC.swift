//
//  FeeApplicationVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/7/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import PDFKit

class FeeApplicationVC: UIViewController {
    
    let fileURL: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/trile-6bbdc.appspot.com/o/Fee%20Application%2FFee%20Application.pdf?alt=media&token=f4702080-ce8f-4827-9011-8e7e92d20213")!
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPDF()
    }
    
    func showPDF() {
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if let document = PDFDocument(url: fileURL) {
            pdfView.document = document
        }
    }
}
