//
//  DocumentCollectionVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/3/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseStorage

class DocumentCollectionVC: UICollectionViewController {
    
    @IBOutlet var documentCollectionView: UICollectionView!
    
    private let REUSE_IDENTIFIER = "customDocumentCell"
    
    let documents: [Document] = []
    let images = ["airplane", "arctichare", "baboon", "boat", "cat", "fruits", "girl", "goldhill", "monarch", "mountain", "sails", "serrano", "tulips"]
    
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
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "test/\(randomID).png")
        
        let testImage: UIImage = UIImage(named: "airplane")!
    
        //Convert UIImage into a data object. Raise compression quality or try png if image quality suffers
        guard let imageData = testImage.jpegData(compressionQuality: 0.75) else {
            print("Error producing image data")
            return
        }
        
        //optional: upload meta data
        let metaData = StorageMetadata.init()
        metaData.contentType = "image/jpeg"
        //upload file
        uploadRef.putData(imageData, metadata: metaData) { (downloadMetaData, error) in
            if let error = error {
                print("Error uploading data: \(error.localizedDescription)")
                return
            }
            print("Upload complete: \(String(describing: downloadMetaData))")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath as IndexPath) as! DocumentCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.documentImageView.image = UIImage(named: images[indexPath.item])
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
