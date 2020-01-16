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
    
    let CELL_NIB_NAME = "ClientTableViewCell"
    let REUSE_IDENTIFIER = "customClientCell"
    let FILE_NUMBER_SEGUE = "goToFileNumberTableVC"

    let dbm = FirebaseFirestoreManager()
    let imageManager = FirebaseStorageManager()
    let alert = AlertPresenterManager()
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    var clients = [Client]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClientButton(_:)))
        navigationItem.rightBarButtonItem = addClientButton
        
        tableView.register(UINib(nibName: CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dbm.readClientsFromDatabase(completion: { (clientArray, success) in
            if success {
                self.clients = clientArray
                self.tableView.reloadData()
            }
        })
    }
    
    //Mark: Bar Buttons
    
    @objc
    func addClientButton(_ sender: UIBarButtonItem) {
        alert.addClientAlertDialog(fromViewController: self) { (clientArray, success) in
            if success {
                self.clients = clientArray
                self.tableView.reloadData()
            } else {
                print("Unable to present alert")
            }
        }
    }
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  REUSE_IDENTIFIER, for: indexPath) as! ClientTableViewCell

//        imageManager.downloadClientImageFromStorage(clients[indexPath.row]) { (success) in
//            if success {
//                cell.clientImageView.image = UIImage(data: self.clients[indexPath.row].imageData)
//            }
//        }
        
        cell.clientNameLabel.text = clients[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dbm.deleteClientFromDatabase(clients, indexPath)
        
        clients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: FILE_NUMBER_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FileNumberTableVC

        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedClient = clients[indexPath.row]
        }
    }
    
}
