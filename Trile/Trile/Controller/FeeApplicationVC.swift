//
//  FeeApplicationVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/7/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PDFKit

class FeeApplicationVC: UIViewController {
    
    let fileURL: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/trile-6bbdc.appspot.com/o/Fee%20Application%2FFee%20Application.pdf?alt=media&token=f4702080-ce8f-4827-9011-8e7e92d20213")!

    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let printButton = UIBarButtonItem(title: "Print", style: .done, target: self, action: #selector(printPDF(_:)))
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItems = [signOutButton, printButton]
        
        //showPDF()
        //getFieldNames()
        
        if let document = PDFDocument(url: fileURL) {
            for index in 0..<document.pageCount{
                if let page = document.page(at: index){
                    let annotations = page.annotations
                    for annotation in annotations{
                        if annotation.fieldName == "FileNo"{
                            print("FileNo Found")
                            annotation.setValue("Test", forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                            addPDFToDatabase(PDF: document)
                            readPDFDataFromDatabase()
                        }
                    }
                }
            }
        }
        
    }
    
    //MARK: Database CRUD Functions
    
    func addPDFToDatabase(PDF pdfDocument: PDFDocument) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
                
        let pdfData = ["pdf_data": pdfDocument.dataRepresentation()]
        
        fileNumberRef.document(fileNumberDocumentID).setData(pdfData as [String : Any], merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("PDF Data Successfully Written")
            }
        }
        
    }
    
    func readPDFDataFromDatabase() {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        
        let query = fileNumberRef.whereField("document_id", isEqualTo: fileNumberDocumentID as Any)
        print(fileNumberDocumentID)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let documentData: [String: Any] = document.data()
                    
                    if let pdfData = documentData["pdf_data"] {
                        self.selectedFileNumber?.pdfData = pdfData as! Data
                        
                        self.showModifiedPDF(fileNumber: self.selectedFileNumber!)
                    }
                }
            }
        }
    }
    
    //MARK: Bar Buttons
    
    @objc
    func printPDF(_ sender: UIBarButtonItem) {
        print("Print button wired up")
    }
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
    }
    
    //MARK: Segues
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
    
    //MARK: PDF Functions
    
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
    
    func showModifiedPDF(fileNumber: FileNumber) {
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let pdfData = fileNumber.pdfData
        if let document = PDFDocument(data: pdfData) {
            pdfView.document = document
        }
    }
    
    func getFieldNames() {
        //guard let path = Bundle.main.url(forResource: FEE_APPLICATION, withExtension: "pdf") else { return }
        
        if let document = PDFDocument(url: fileURL) {
            for index in 0..<document.pageCount{
                if let page = document.page(at: index){
                    let annotations = page.annotations
                    for annotation in annotations{
                        print("Annotation Name :: \(annotation.fieldName ?? "")")
                        if annotation.fieldName == "FileNo"{
                            annotation.setValue("Test", forAnnotationKey: .widgetValue)
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        }else if annotation.fieldName == "checkBox"{
                            annotation.buttonWidgetState = .onState
                            page.removeAnnotation(annotation)
                            page.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
}
