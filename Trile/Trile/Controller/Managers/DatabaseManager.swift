//
//  DatabaseManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/13/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DatabaseManager {
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid

    //MARK: Client Functions
    
    func addClientToDatabase(_ client : Client) {
        let clientRef = db.collection("users").document(uid).collection("clients")

        let newID = clientRef.document().documentID
        client.documentID = newID
        
        let clientData: [String: Any] = ["name": client.name, "document_id": client.documentID]
        
        clientRef.document(newID).setData(clientData) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("New ID: \(newID)")
                print("Document successfully written!")
            }
        }
    }
    
    func readClientsFromDatabase(completion: @escaping ((_ clientArray: [Client], _ success: Bool) -> Void)) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        
        var clientArray = [Client]()

        clientRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let newClient = Client()
                    
                    if let name = document.get("name") {
                        newClient.name = name as! String
                    }

                    let id = document.documentID
                    newClient.documentID = id
                    clientArray.append(newClient)
                }
                completion(clientArray, true)
            }
        }
    }
    
    func deleteClientFromDatabase(_ clientArray: [Client], _ indexPath: IndexPath) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        let documentID = clientArray[indexPath.row].documentID
        clientRef.document(documentID).delete()
    }
    
    //MARK: File Number Functions
    
    func addFileNumberToDatabase(_ client: Client, _ fileNumber : FileNumber) {
        let clientDocumentID = client.documentID
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        let newID = fileNumberRef.document().documentID
        
        fileNumber.documentID = newID
        
        fileNumberRef.document(newID).setData([
            "assigned_file_number": fileNumber.assignedFileNumber,
            "document_id": fileNumber.documentID
        ]) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("New ID: \(newID)")
                print("Document successfully written!")
            }
        }
    }
    
    func readFileNumbersFromDatabase(_ client: Client, completion: @escaping ((_ fileNumberArray: [FileNumber], _ success: Bool) -> Void)) {
        
        let clientDocumentID = client.documentID
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        
        var fileNumberArray = [FileNumber]()
        
        fileNumberRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let newFileNumber = FileNumber()
                    
                    if let assignedFileNumber = document.get("assigned_file_number") {
                        newFileNumber.assignedFileNumber = assignedFileNumber as! String
                    }
                    
                    let id = document.documentID
                    newFileNumber.documentID = id
                    fileNumberArray.append(newFileNumber)
                }
                completion(fileNumberArray, true)
            }
        }
    }
    
    func deleteFileNumberFromDatabase(_ client: Client, _ fileNumberArray: [FileNumber], _ indexPath: IndexPath) {
        let clientDocumentID = client.documentID
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        let fileNumberDocumentID = fileNumberArray[indexPath.row].documentID
        fileNumberRef.document(fileNumberDocumentID).delete()
    }
    
    //MARK: Case Functions
    
    func addCaseDataToDatabase(_ client: Client, _ fileNumber: FileNumber, _ caseData: [String: Any]) {
        let clientDocumentID = client.documentID
        let fileNumberDocumentID = fileNumber.documentID
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        
        fileNumberRef.document(fileNumberDocumentID).setData(caseData, merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    //MARK: Document Functions
    
    func addDocumentToDatabase(_ client: Client, _ fileNumber: FileNumber, _ document: Document) {
        let clientDocumentID = client.documentID
        let fileNumberDocumentID = fileNumber.documentID
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        let newID = documentRef.document().documentID
        
        let documentData: [String: Any] = [
            "document_id": newID,
            "uuid": document.uuid,
            "image_path": document.imagePath,
            "image_data": document.imageData
            ]
        
        documentRef.document(newID).setData(documentData, merge: true) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func readDocumentsFromDatabase(_ client: Client, _ fileNumber: FileNumber, completion: @escaping ((_ documentArray: [Document], _ success: Bool) -> Void)) {
        
        let clientDocumentID = client.documentID
        let fileNumberDocumentID = fileNumber.documentID
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        var documentArray = [Document]()
        
        documentRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {

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
                    
                    documentArray.append(newDocument)
                }
                completion(documentArray, true)
            }
        }
    }
    
    func deleteDocumentFromDatabase(_ client: Client, _ fileNumber: FileNumber, _ documentArray: [Document], _ indexPath: IndexPath) {
        let clientDocumentID = client.documentID
        let fileNumberDocumentID = fileNumber.documentID
        
        let clientRef = db.collection("users").document(uid).collection("clients")
        let fileNumberRef = clientRef.document(clientDocumentID).collection("file_numbers")
        let documentRef = fileNumberRef.document(fileNumberDocumentID).collection("documents")
        
        let documentID = documentArray[indexPath.item].documentID
        documentRef.document(documentID).delete()
    }
    
}
