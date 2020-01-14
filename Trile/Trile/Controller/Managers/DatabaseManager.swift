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
        
        clientRef.document(newID).setData([
            "name": client.name,
            "document_id": client.documentID
        ]) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("New ID: \(newID)")
                print("Document successfully written!")
            }
        }
        
    }
    
}
