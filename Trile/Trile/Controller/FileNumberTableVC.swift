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
    
    let dbm = DatabaseManager()
    
    let TAB_SEGUE = "goToTabBarVC"
    
    var selectedClient: Client?
    var fileNumbers = [FileNumber]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addFileNumberButton
        
        readFileNumbersFromDatabase()
    }
    
    // MARK: Table View
    
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
        
        deleteFileNumberFromDatabase(indexPath)
        
        fileNumbers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //MARK: Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TAB_SEGUE, sender: self)
    }
    
    //Load the details for the selected file number
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as? UITabBarController
        
        let caseDetailsNavBarController = tabBarController?.viewControllers?[0] as? UINavigationController
        let documentsNavBarController = tabBarController?.viewControllers?[1] as? UINavigationController
        let feeApplicationNavBarController = tabBarController?.viewControllers?[2] as? UINavigationController
        let clientDetailsNavBarController = tabBarController?.viewControllers?[3] as? UINavigationController

        let destinationCaseDetailsVC = caseDetailsNavBarController?.topViewController as? CaseDetailsVC
        let destinationDocumentCollectionVC = documentsNavBarController?.topViewController as? DocumentCollectionVC
        let destinationFeeApplicationVC = feeApplicationNavBarController?.topViewController as? FeeApplicationVC
        let destinationClientDetailsVC = clientDetailsNavBarController?.topViewController as? ClientDetailsVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationCaseDetailsVC?.selectedClient = selectedClient
            destinationCaseDetailsVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationDocumentCollectionVC?.selectedClient = selectedClient
            destinationDocumentCollectionVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationFeeApplicationVC?.selectedClient = selectedClient
            destinationFeeApplicationVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationClientDetailsVC?.selectedClient = selectedClient
            destinationClientDetailsVC?.selectedFileNumber = fileNumbers[indexPath.row]
        }
    }
    
    //MARK: Database CRUD Functions
    

    
    func readFileNumbersFromDatabase() {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID") }
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        
        //File Numbers are completely removed and replaced in the array. Write this better in the future.
        fileNumbers.removeAll()
        
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
                    self.fileNumbers.append(newFileNumber)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteFileNumberFromDatabase(_ indexPath: IndexPath) {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID") }
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        let fileNumberDocumentID = fileNumbers[indexPath.row].documentID
        fileNumberRef.document(fileNumberDocumentID).delete()
    }
    
    //MARK: Alert Dialog
    
    @objc
    func addFileNumberAlertDialog(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New File Number", message: "Enter File Number", preferredStyle: .alert)
        let addFileNumberAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newFileNumber = FileNumber()
            
            if let newAssignedFileNumber = textField.text {
                newFileNumber.assignedFileNumber = newAssignedFileNumber
                
                if let client = self.selectedClient {
                    self.dbm.addFileNumberToDatabase(client, newFileNumber)
                }
                self.readFileNumbersFromDatabase()
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
