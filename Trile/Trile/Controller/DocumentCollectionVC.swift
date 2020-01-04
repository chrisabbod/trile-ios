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
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    let documents: [Document] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanDocumentButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(scanDocument(_:)))
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut(_:)))
        
        navigationItem.rightBarButtonItems = [signOutButton, scanDocumentButton]
        
        //Register .xib file
        documentCollectionView.register(UINib(nibName: "DocumentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    }
    
    //MARK: Segues
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
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
    
    //MARK: Image Functions

    func uploadImageToStorage(_ scannedImage: UIImage) {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "\(uid)/\(randomID).jpeg")
                
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
            print("Upload complete: \(String(describing: downloadMetaData))")
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath as IndexPath) as! DocumentCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.documentImageView.image = UIImage(named: documents[indexPath.item]) //RETURN UIIMAGE HERE
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
        
        uploadImageToStorage(results.scannedImage)
        
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
