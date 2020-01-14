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
    
}
