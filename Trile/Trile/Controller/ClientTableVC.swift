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
    let LOAD_TABLEVIEW_NOTIFICATION = "loadClientTableVC"
    let EDIT_USER_INFO_IDENTIFIER = "EditUserInfoVC"
    let EDIT_USER_INFO_BAR_BUTTON = "User Info"
    let PLACEHOLDER_VC_IDENTIFIER = "PlaceholderVC"
    let SHOW_CHOOSE_CLIENT_PLACEHOLDER = "showChooseClientPlaceholder"

    let dbm = FirebaseFirestoreManager()
    let imageManager = FirebaseStorageManager()
    let alert = AlertPresenterManager()
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    var clients = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addEditUserInfoButton = UIBarButtonItem(title: EDIT_USER_INFO_BAR_BUTTON, style: .done, target: self, action: #selector(addEditUserInfoButton(_:)))
        let addClientButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClientButton(_:)))
        navigationItem.rightBarButtonItems = [addClientButton, addEditUserInfoButton]
        
        tableView.register(UINib(nibName: CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
        
        //Reload ClientTableVC when changes are made in EditClientDetailsVC
        NotificationCenter.default.addObserver(self, selector: #selector(loadClients), name: NSNotification.Name(rawValue: LOAD_TABLEVIEW_NOTIFICATION), object: nil)
        
        //Display Choose A Client screen when a client is added
        NotificationCenter.default.addObserver(self, selector: #selector(showChooseClientPlaceholder), name: NSNotification.Name(rawValue: SHOW_CHOOSE_CLIENT_PLACEHOLDER), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClients { (success) in
            if success {
                if self.clients.isEmpty {
                    self.showAddClientPlaceholder()
                } else {
                    self.showChooseClientPlaceholder()
                }
            }
        }
    }
    
    //MARK: Load Clients Function
    
    @objc
    func loadClients(completion: @escaping (_ success: Bool) -> Void) {
        dbm.readClientsFromDatabase(completion: { (clientArray, success) in
            if success {
                self.clients = clientArray
                self.tableView.reloadData()
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    //Mark: Bar Buttons
    
    @objc
    func addEditUserInfoButton(_ sender: UIBarButtonItem) {
        let editUserInfoVC = EditUserInfoVC(nibName: EDIT_USER_INFO_IDENTIFIER, bundle: nil)
        self.splitViewController?.showDetailViewController(editUserInfoVC, sender: self)
    }
    
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
    
    //MARK: Show Placeholder Functions
    
    @objc
    func showAddClientPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.addClient = true
        
        self.splitViewController?.showDetailViewController(placeholderVC, sender: self)
    }
    
    @objc
    func showChooseClientPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.chooseClient = true
        
        self.splitViewController?.showDetailViewController(placeholderVC, sender: self)
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
        
        imageManager.downloadClientImageFromStorage(clients[indexPath.row]) { (imageData, success) in
            if imageData.count < 10000 {
                cell.clientImageView.image = UIImage(named: "avatar_placeholder")
            } else {
                cell.clientImageView.image = UIImage(data: imageData)
            }
        }
        
        let first = clients[indexPath.row].firstName
        let last = clients[indexPath.row].lastName

        cell.clientNameLabel.text = Utils.formatNameForClientTableView(firstName: first, lastName: last)
        
        self.tableView.backgroundColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dbm.deleteClientFromDatabase(clients, indexPath)
        
        clients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        if clients.isEmpty {
            showAddClientPlaceholder()
        }
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
