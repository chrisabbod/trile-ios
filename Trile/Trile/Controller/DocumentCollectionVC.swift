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
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let testArray = ["airplane", "baboon", "boat", "cat", "sails", "tulips"]
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var documents: [Document] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    //MARK: Load Documents
    
    func loadDocuments() {
        readDocumentsFromDatabase() { (success) in
            if success {
                self.downloadImagesFromStorage(self.documents) { (success) in
                    if success {
                        print("Success")
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
    
    func addDocumentToDatabase(_ document: Document) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID")}
        guard let fileNumberDocumentID = selectedFileNumber?.documentID else { return print("Could not get file number document ID")}
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        let newID = documentRef.document().documentID
        
        let documentData = [
            "document_id": newID,
            "uuid": document.uuid,
            "image_path": document.imagePath
        ]
        
        documentRef.document(newID).setData(documentData, merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
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
    //MARK: Image Functions

    func uploadImageToStorage(_ scannedImage: UIImage, completion: @escaping ((_ success: Bool) -> Void)) {
        let randomUUID = UUID.init().uuidString
        let imagePath = "\(uid)/\(randomUUID).jpeg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
                
        //Convert UIImage into a data object. Raise compression quality or try png if image quality suffers
        guard let imageData = scannedImage.jpegData(compressionQuality: 0.75) else {
            print("Error producing image data")
            return
        }
        
        //optional: upload meta data
        let metaData = StorageMetadata.init()
        metaData.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: metaData) { (downloadMetaData, error) in
            if let error = error {
                print("Error uploading data: \(error.localizedDescription)")
                return
            }
            print("Upload complete")
            //print("Upload complete: \(String(describing: downloadMetaData))")
            completion(true)
        }
        
        let newDocument = Document()
        newDocument.uuid = randomUUID
        newDocument.imagePath = imagePath
        
        addDocumentToDatabase(newDocument)
    }
    
    func downloadImagesFromStorage(_ documentArray: [Document], completion: @escaping ((_ success: Bool) -> Void)) {
        print("Document Passed To Array: \(documentArray.count)")
        
        for document in documentArray {
            let storageRef = Storage.storage().reference(withPath: document.imagePath)
            
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error retrieving image data: \(error.localizedDescription)")
                }
                
                if let data = data {
                    document.imageData = data
                    //print("Document: \(document.documentID) Total Image Data => \(document.imageData)")
                }
                completion(true)
            }
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath as IndexPath) as! DocumentCollectionViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.documentImageView.image = UIImage(data: documents[indexPath.item].imageData)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}

//MARK: Collectionview FlowLayout Extension

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
}

//MARK: WeScan Functions Extension

extension DocumentCollectionVC: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        
        uploadImageToStorage(results.scannedImage) { (success) in
            if success {
                print("Successfully uploaded document after scanning")
                self.loadDocuments()
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
