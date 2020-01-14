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
    let alert = AlertPresenterManager()
    
    let TAB_SEGUE = "goToTabBarVC"
    
    var selectedClient: Client?
    var fileNumbers = [FileNumber]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberButton(_:)))
        navigationItem.rightBarButtonItem = addFileNumberButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let client = self.selectedClient {
            self.dbm.readFileNumbersFromDatabase(client) { (fileNumberArray, success) in
                if success {
                    self.fileNumbers = fileNumberArray
                    self.tableView.reloadData()
                } else {
                    print("Unable to read file number data from database")
                }
            }
        }
    }
    
    //MARK: Bar Button Functions
    
    @objc
    func addFileNumberButton(_ sender: UIBarButtonItem) {
        if let client = selectedClient {
            alert.addFileNumberAlertDialog(fromViewController: self, withClient: client) { (fileNumberArray, success) in
                if success {
                    self.fileNumbers = fileNumberArray
                    self.tableView.reloadData()
                } else {
                    print("Unable to present alert")
                }
            }
        }
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
        
        if let client = selectedClient {
            dbm.deleteFileNumberFromDatabase(client, fileNumbers, indexPath)
        }
        
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
    
}
