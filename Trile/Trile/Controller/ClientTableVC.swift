//
//  MasterViewController.swift
//  Trile
//
//  Created by Chris Abbod on 12/26/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ClientTableVC: UITableViewController {
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    var clients = [Client]()
    
    let FILE_NUMBER_SEGUE = "goToFileNumberTableVC"
    
    var testModeCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableNavBarGestureRecognizer() //Enabled to allow userdebug options on tap
        
        readClientsFromDatabase()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClientAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addClientButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readClientsFromDatabase()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let client = clients[indexPath.row].name
        cell.textLabel!.text = client
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteClientFromDatabase(indexPath)
        
        clients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: FILE_NUMBER_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FileNumberTableVC

        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedClient = clients[indexPath.row]
        }
    }
    
    //MARK: - Database CRUD Functions
    
    func addClientToDatabase(_ client : Client) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        
        let newID = clientRef.document().documentID
        client.documentID = newID
        
        clientRef.document(newID).setData([
            "name": client.name,
            "documentID": client.documentID
        ]) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("New ID: \(newID)")
                print("Document successfully written!")
            }
        }
        
    }
    
    func readClientsFromDatabase() {
        let clientRef = db.collection("users").document(uid).collection("clients")
        
        //Clients are completely removed and replaced in the array. Write this better in the future.
        clients.removeAll()
        
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
                    self.clients.append(newClient)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteClientFromDatabase(_ indexPath: IndexPath) {
        let clientRef = db.collection("users").document(uid).collection("clients")
        let documentID = clients[indexPath.row].documentID
        clientRef.document(documentID).delete()
    }
    
    //MARK: - Alert Dialog
    
    @objc
    func addClientAlertDialog(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Client", message: "Enter Client Name", preferredStyle: .alert)
        let addClientAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newClient = Client()
            
            if let name = textField.text {
                newClient.name = name
                
                self.addClientToDatabase(newClient)
                self.readClientsFromDatabase()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("No client added")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addClientAction)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Enter Client Name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Test Functions
    
    @objc
    func insertTestClients() {
        for i in (1...5).reversed() {
            let newClient = Client()
            newClient.name = "Client " + String(i)
            
            addClientToDatabase(newClient)
        }
        readClientsFromDatabase()
    }
    
    @objc
    func removeAllClients() {
        let clientRef = db.collection("users").document(uid).collection("clients")
        
        for client in clients {
            clientRef.document(client.documentID).delete()
        }
        
        clients.removeAll()
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
            let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addClientAlertDialog(_:)))
            let addTestClientsButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.insertTestClients))
            let removeClientsButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.removeAllClients))
            
            self.navigationItem.rightBarButtonItems = [addClientButton, addTestClientsButton, removeClientsButton]
        }
        
        let disableAction = UIAlertAction(title: "Disable", style: .default) { (action) in
            let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addClientAlertDialog(_:)))
            
            self.navigationItem.rightBarButtonItems = [addClientButton]
        }
        
        alert.addAction(disableAction)
        alert.addAction(enableAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


