//
//  DocumentImageManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/14/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FirebaseStorageManager {
    
    let dbm = FirebaseFirestoreManager()
    
    let uid: String = Auth.auth().currentUser!.uid
    
    func uploadClientImageToStorage(_ client: Client, _ scannedImage: UIImage, completion: @escaping ((_ success: Bool) -> Void)) {
        
        let clientDocumentID = client.documentID
        
        let imagePath = "\(uid)/\(clientDocumentID)/\(clientDocumentID).jpeg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        
        //Convert UIImage into a data object. Raise compression quality or try png if image quality suffers
        guard let imageData = scannedImage.jpegData(compressionQuality: 0.75) else {
            print("Error producing image data")
            return
        }
        
        //optional: upload meta data
        let metaData = StorageMetadata.init()
        metaData.contentType = "image/jpeg"
        
        let newClient = Client()
        
        uploadRef.putData(imageData, metadata: metaData) { (downloadMetaData, error) in
            newClient.documentID = clientDocumentID
            newClient.clientImageUUID = clientDocumentID
            newClient.clientImagePath = imagePath
            newClient.clientImageData = imageData
            
            let imageData: [String: Any] = [
                "client_image_uuid": newClient.clientImageUUID,
                "client_image_path": newClient.clientImagePath,
                "client_image_data": newClient.clientImageData
            ]
            
            self.dbm.addClientDataToDatabase(newClient, imageData)
            //self.dbm.addDocumentToDatabase(client, fileNumber, newDocument)
            
            if let error = error {
                print("Error uploading data: \(error.localizedDescription)")
                return
            }
            print("Upload complete: \(String(describing: downloadMetaData))")
            completion(true)
        }
    }
    
    func uploadImageToStorage(_ client: Client, _ fileNumber: FileNumber, _ scannedImage: UIImage, completion: @escaping ((_ success: Bool) -> Void)) {
        
        let clientDocumentID = client.documentID
        let fileNumberDocumentID = fileNumber.documentID
        
        let randomUUID = UUID.init().uuidString
        let imagePath = "\(uid)/\(clientDocumentID)/\(fileNumberDocumentID)/\(randomUUID).jpeg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        
        //Convert UIImage into a data object. Raise compression quality or try png if image quality suffers
        guard let imageData = scannedImage.jpegData(compressionQuality: 0.75) else {
            print("Error producing image data")
            return
        }
        
        //optional: upload meta data
        let metaData = StorageMetadata.init()
        metaData.contentType = "image/jpeg"
        
        let newDocument = Document()
        
        uploadRef.putData(imageData, metadata: metaData) { (downloadMetaData, error) in
            newDocument.uuid = randomUUID
            newDocument.imagePath = imagePath
            newDocument.imageData = imageData
            
            self.dbm.addDocumentToDatabase(client, fileNumber, newDocument)
            
            if let error = error {
                print("Error uploading data: \(error.localizedDescription)")
                return
            }
            print("Upload complete: \(String(describing: downloadMetaData))")
            completion(true)
        }
    }
    
    func downloadImagesFromStorage(_ documentArray: [Document], completion: @escaping ((_ success: Bool) -> Void)) {
        //print("Document Passed To Array: \(documentArray.count)")
        
        for document in documentArray {
            let storageRef = Storage.storage().reference(withPath: document.imagePath)
            
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error retrieving image data: \(error.localizedDescription)")
                }
                
                if let data = data {
                    document.imageData = data
                    print("Document: \(document.documentID) Total Image Data => \(document.imageData)")
                }
                completion(true)
            }
        }
    }
    
    func deleteDocumentFromStorage(_ documentArray: [Document], _ indexPath: IndexPath, completion: @escaping ((_ success: Bool) -> Void)) {
        let storageRef = Storage.storage().reference()
        
        let imagePath = storageRef.child(documentArray[indexPath.item].imagePath)
        
        imagePath.delete { error in
            if let error = error {
                print("Problem deleting file from storage \(error.localizedDescription)")
            } else {
                print("File deleted successfully")
                completion(true)
            }
        }
    }
}
