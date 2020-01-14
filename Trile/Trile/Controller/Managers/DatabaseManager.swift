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

    //MARK: - Client Functions
    
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
    
    //MARK: - File Number Functions
    
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
}
