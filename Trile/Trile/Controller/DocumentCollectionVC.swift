//
//  DocumentCollectionVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/3/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import WeScan
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DocumentCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var documentCollectionView: UICollectionView!
    
    private let REUSE_IDENTIFIER = "customDocumentCell"
    private let DOCUMENT_DETAIL_SEGUE = "goToDocumentDetailsVC"
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = DatabaseManager()
    let imageManager = DocumentImageManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var documents: [Document] = []
    
    var documentImageData: Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let scanDocumentButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanDocument(_:)))
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItems = [signOutButton, scanDocumentButton]
        
        //Register .xib file
        documentCollectionView.register(UINib(nibName: "DocumentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDocuments()
    }
    
    //MARK: Bar Buttons Functions
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
    }
    
    @objc
    func scanDocument(_ sender: Any) {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    
    //MARK: Segues
    
    func transitionToHome() {
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DocumentDetailsVC
        
        //We use .first because collectionView indexPathsForSelectedItems grabs multiple indexPaths
        if let indexPath = documentCollectionView.indexPathsForSelectedItems?.first {
            destinationVC.selectedDocument = documents[indexPath.item]
        }
    }
    
    //MARK: Load Documents
    
    func loadDocuments() {
        readDocumentsFromDatabase() { (success) in
            if success {
                self.imageManager.downloadImagesFromStorage(self.documents) { (success) in
                    if success {
                        self.documentCollectionView.reloadData()
                    } else {
                        print("Failure")
                    }
                }
            } else {
                print("No documents returned from database")
            }
        }
    }
    
    //MARK: Database CRUD Functions
    

    
    func readDocumentsFromDatabase(completion: @escaping ((_ success: Bool) -> Void)) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        documentRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.documents.removeAll()
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let newDocument = Document()
                    
                    if let documentID = document.get("document_id") {
                        newDocument.documentID = documentID as! String
                    }
                    
                    if let uuid = document.get("uuid") {
                        newDocument.uuid = uuid as! String
                    }
                    
                    if let imagePath = document.get("image_path") {
                        newDocument.imagePath = imagePath as! String
                    }
                    
                    self.documents.append(newDocument)
                }
                completion(true)
            }
        }
    }
    
    func deleteDocumentFromDatabase(_ indexPath: IndexPath) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        let documentID = documents[indexPath.item].documentID
        documentRef.document(documentID).delete()
    }
    
    //MARK: Image Functions
    
    

    
    func deleteDocumentFromStorage(_ indexPath: IndexPath, completion: @escaping ((_ success: Bool) -> Void)) {
        let storageRef = Storage.storage().reference()
        
        let imagePath = storageRef.child(documents[indexPath.item].imagePath)
        
        imagePath.delete { error in
            if let error = error {
                print("Problem deleting file from storage \(error.localizedDescription)")
            } else {
                print("File deleted successfully")
                completion(true)
            }
        }
    }
    
    //MARK: Collectionview Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath as IndexPath) as! DocumentCollectionViewCell

        cell.documentImageView.image = UIImage(data: documents[indexPath.item].imageData)
        
        addCornerRadiusToViews(cell)
        
        return cell
    }
    
    //MARK: CV Editing Functions
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let indexPaths = documentCollectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = documentCollectionView.cellForItem(at: indexPath) as! DocumentCollectionViewCell
            cell.isInEditingMode = editing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            deleteDocumentAlertDialog(indexPath)
        } else {
            performSegue(withIdentifier: DOCUMENT_DETAIL_SEGUE, sender: self)
        }
        
    }
}

//MARK: CV FlowLayout Extension

extension DocumentCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: 240, height: 300)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return sectionInset
    }
    
    //MARK: Alert Dialog
    
    func deleteDocumentAlertDialog(_ indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Document", message: "Would you like to delete this document?", preferredStyle: .alert)
        let deleteDocumentAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            self.deleteDocumentFromStorage(indexPath) { (success) in
                self.deleteDocumentFromDatabase(indexPath)
                self.documents.remove(at: indexPath.item)
                self.documentCollectionView.reloadData()
            }

            print("Document deleted")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("No document deleted")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteDocumentAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: UI Beautification Functions
    
    func setBackgroundColor() {
        documentCollectionView.backgroundColor = UIColor(red: 231/255, green: 229/255, blue: 243/255, alpha: 1)
    }
    
    func addCornerRadiusToViews(_ cell: UICollectionViewCell) {
        let borderWidthValue: CGFloat = 2.0
        let cornerRadiusValue: CGFloat = 20.0
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = borderWidthValue
        cell.layer.cornerRadius = cornerRadiusValue
    }
}

//MARK: WeScan Functions Extension

extension DocumentCollectionVC: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            imageManager.uploadImageToStorage(client, fileNumber, results.scannedImage) { (success) in
                if success {
                    print("Successfully uploaded document after scanning")
                    self.loadDocuments()
                }
            }

        }
        
        scanner.dismiss(animated: true) {
            print("Scanner dismissed")
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true) {
            print("Scanner dismissed")
        }
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
}
