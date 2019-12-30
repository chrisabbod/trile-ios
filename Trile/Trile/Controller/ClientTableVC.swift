//
//  MasterViewController.swift
//  Trile
//
//  Created by Chris Abbod on 12/26/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ClientTableVC: UITableViewController {
    
    var testModeCounter: Int = 0

    var detailViewController: DetailViewController? = nil
    var objects = [Client]()
    
    var docRef: DocumentReference!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        enableNavBarGestureRecognizer() //Enabled to allow userdebug options on tap
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClientAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addClientButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues

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

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //MARK: - Insert Function
    
    func insertNewClient(_ client: Client) {
        objects.insert(client, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
        //MARK: - Database CRUD Functions
        
    func addClientToDatabase(_ clientName : String) {
        
        let chrisData: [String: Any] = ["user": ["first_name": "Chris", "last_name": "Abbod", "age": 31]]
        
        db.collection("users").document("8Dzaxgg0VAh4jjWd9meH").setData(chrisData, completion: { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        })
    }
        
//        db.collection("user").document("id").setData([
//            "name": clientName
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//    }
    
    //MARK: - Alert Dialog
    
    @objc
    func addClientAlertDialog(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Client", message: "Enter Client Name", preferredStyle: .alert)
        let addClientAction = UIAlertAction(title: "Add", style: .default) { (action) in
//            let newClient = Client()
//
//            if let name = textField.text {
//                newClient.name = name
//            }
//
//            self.insertNewClient(newClient)
            
            if let name = textField.text {
                self.addClientToDatabase(name)
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
            
            objects.insert(newClient, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc
    func removeAllClients() {
        objects.removeAll()
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


