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
    
    let TAB_SEGUE = "goToTabBarVC"
    
    var selectedClient: Client?
    var fileNumbers = [FileNumber]()
    
    var testModeCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableNavBarGestureRecognizer()
        
        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addFileNumberButton
        
        readFileNumbersFromDatabase()
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
        
        deleteFileNumberFromDatabase(indexPath)
        
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
    
    //MARK: - Test Functions
    
    @objc
    func insertTestFileNumbers() {
        for i in (1...10).reversed() {
            let newFileNumber = FileNumber()
            newFileNumber.assignedFileNumber = "Filenumber " + String(i)
            
            addFileNumberToDatabase(newFileNumber)
        }
        readFileNumbersFromDatabase()
    }
    
    @objc
    func removeAllFileNumbers() {
        guard let clientDocumentID = selectedClient?.documentID else { return print("Could not get client document ID") }
        let fileNumberRef = db.collection("users").document(uid).collection("clients").document(clientDocumentID).collection("file_numbers")
        for fileNumber in fileNumbers {
            fileNumberRef.document(fileNumber.documentID).delete()
        }
        
        fileNumbers.removeAll()
        tableView.reloadData()
    }
    
    func enableNavBarGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(countPresses))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc
    func countPresses() {
        testModeCounter += 1
        
        if testModeCounter == 5 {
            enableUserDebugModeAlertDialog()
            testModeCounter = 0
        }
    }
    
    @objc
    func enableUserDebugModeAlertDialog() {
        let alert = UIAlertController(title: "Test Menu", message: "Enable Test Mode?", preferredStyle: .alert)
        
        let enableAction = UIAlertAction(title: "Enable", style: .default) { (action) in
            let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addFileNumberAlertDialog(_:)))
            let addTestFileNumbersButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.insertTestFileNumbers))
            let removeFileNumbersButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeAllFileNumbers))
            
            self.navigationItem.rightBarButtonItems = [addFileNumberButton, addTestFileNumbersButton, removeFileNumbersButton]
        }
        
        let disableAction = UIAlertAction(title: "Disable", style: .default) { (action) in
            let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addFileNumberAlertDialog(_:)))
            
            self.navigationItem.rightBarButtonItems = [addFileNumberButton]
        }
        
        alert.addAction(disableAction)
        alert.addAction(enableAction)
        
        present(alert, animated: true, completion: nil)
    }
}
