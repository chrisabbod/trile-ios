//
//  FileNumberTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/31/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FileNumberTableVC: UITableViewController {
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let TAB_SEGUE = "goToTabVC"
    
    var selectedClient: Client?
    var fileNumbers = [FileNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addFileNumberButton
    }
    
    //MARK: - Insert Function
    
    func insertNewFileNumber(_ fileNumber: FileNumber) {
        fileNumbers.insert(fileNumber, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNumbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fileNumber = fileNumbers[indexPath.row].assignedFileNumber
        cell.textLabel!.text = fileNumber
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //        deleteFileNumberFromDatabase(indexPath)
        
        fileNumbers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //MARK: - Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TAB_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "showDetail" {
        //            print("Go to FileNumberTableVC")
        //            if let indexPath = tableView.indexPathForSelectedRow {
        //                let object = objects[indexPath.row] as! Client
        //                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        //                controller.detailItem = object
        //                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        //                controller.navigationItem.leftItemsSupplementBackButton = true
        //                detailViewController = controller
        //            }
        //        }
    }
    
    //MARK: - Database CRUD Functions
    
    func addFileNumberToDatabase(_ fileNumber : FileNumber) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID") }
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        let newID = fileNumberRef.document().documentID
        
        fileNumber.documentID = newID
        
        fileNumberRef.document(newID).setData([
            "name": fileNumber.assignedFileNumber,
            "documentID": fileNumber.documentID
        ]) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("New ID: \(newID)")
                print("Document successfully written!")
            }
        }
        
    }
    
    //   func readClientsFromDatabase() {
    //       let clientRef = db.collection("users").document(uid).collection("clients")
    //
    //       //Clients are completely removed and replaced in the array. Write this better in the future.
    //       clients.removeAll()
    //
    //       clientRef.getDocuments() { (querySnapshot, err) in
    //           if let err = err {
    //               print("Error getting documents: \(err)")
    //           } else {
    //               for document in querySnapshot!.documents {
    //                   //print("\(document.documentID) => \(document.data())")
    //                   let newClient = Client()
    //
    //                   if let name = document.get("name") {
    //                       newClient.name = name as! String
    //                   }
    //
    //                   let id = document.documentID
    //                   newClient.documentID = id
    //                   self.clients.append(newClient)
    //               }
    //               self.tableView.reloadData()
    //           }
    //       }
    //   }
    //
    //   func deleteClientFromDatabase(_ indexPath: IndexPath) {
    //       let clientRef = db.collection("users").document(uid).collection("clients")
    //       let documentID = clients[indexPath.row].documentID
    //       clientRef.document(documentID).delete()
    //   }
    
    //MARK: - Alert Dialog
    
    @objc
    func addFileNumberAlertDialog(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New File Number", message: "Enter File Number", preferredStyle: .alert)
        let addFileNumberAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newFileNumber = FileNumber()
            
            if let newAssignedFileNumber = textField.text {
                newFileNumber.assignedFileNumber = newAssignedFileNumber
                self.addFileNumberToDatabase(newFileNumber)
                //   self.readClientsFromDatabase()
                //self.insertNewFileNumber(newFileNumber)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("No file number added")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addFileNumberAction)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Enter File Number"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
