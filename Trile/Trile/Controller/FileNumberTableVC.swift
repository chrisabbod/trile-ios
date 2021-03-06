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
    
    let CELL_NIB_NAME = "FileNumberTableViewCell"
    let REUSE_IDENTIFIER = "customFileNumberCell"
    let TAB_SEGUE = "goToTabBarVC"
    let LOAD_FILE_NUMBER_NOTIFICATION = "loadFileNumberTableVC"
    let EDIT_USER_INFO_IDENTIFIER = "EditUserInfoVC"
    let EDIT_USER_INFO_BAR_BUTTON = "User Info"
    let PLACEHOLDER_VC_IDENTIFIER = "PlaceholderVC"
    let SHOW_CHOOSE_FILE_NUMBER_PLACEHOLDER = "showChooseFileNumberPlaceholder"

    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    let alert = AlertPresenterManager()
    
    
    var selectedClient: Client?
    var fileNumbers = [FileNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFileNumbersAndShowPlaceholder() //Show placeholder only when initially displaying FileNumberTableVC
        
        let addEditUserInfoButton = UIBarButtonItem(title: EDIT_USER_INFO_BAR_BUTTON, style: .done, target: self, action: #selector(addEditUserInfoButton(_:)))
        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberButton(_:)))
        navigationItem.rightBarButtonItems = [addFileNumberButton, addEditUserInfoButton]
        
        tableView.register(UINib(nibName: CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: REUSE_IDENTIFIER)
        
        //Reload FileNumberTableVC when changes are made in EditCaseDetailsVC
        NotificationCenter.default.addObserver(self, selector: #selector(loadFileNumbersWhenNotificationPosted), name: NSNotification.Name(rawValue: LOAD_FILE_NUMBER_NOTIFICATION), object: nil)
        
        //Display Choose A File Number screen when a file number is added
        NotificationCenter.default.addObserver(self, selector: #selector(showChooseFileNumberPlaceholder), name: NSNotification.Name(rawValue: SHOW_CHOOSE_FILE_NUMBER_PLACEHOLDER), object: nil)
    }
    
    //MARK: Load File Numbers
    
    //This function only used when NSNotification makes a call because the completion handler in
    //loadFileNumbers causes crashes due to EXC_BAD_ACCESS (Bad memory location)
    @objc
    func loadFileNumbersWhenNotificationPosted() {
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
    
    @objc
    func loadFileNumbers(completion: @escaping (_ success: Bool) -> Void) {
        if let client = self.selectedClient {
            self.dbm.readFileNumbersFromDatabase(client) { (fileNumberArray, success) in
                if success {
                    self.fileNumbers = fileNumberArray
                    self.tableView.reloadData()
                    completion(true)
                } else {
                    print("Unable to read file number data from database")
                }
            }
        }
    }
    
    //MARK: Bar Button Functions
    
    @objc
    func addEditUserInfoButton(_ sender: UIBarButtonItem) {
        let editUserInfoVC = EditUserInfoVC(nibName: EDIT_USER_INFO_IDENTIFIER, bundle: nil)
        self.present(editUserInfoVC, animated: true, completion: nil)
    }
    
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
    
    //MARK: Show Placeholder Functions
    
    @objc
    func showAddFileNumberPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.addFileNumber = true
        
        self.splitViewController?.showDetailViewController(placeholderVC, sender: self)
    }
    
    @objc
    func showChooseFileNumberPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.chooseFileNumber = true
        
        self.splitViewController?.showDetailViewController(placeholderVC, sender: self)
    }
    
    func loadFileNumbersAndShowPlaceholder() {
        loadFileNumbers { (success) in
            if success {
                if self.fileNumbers.isEmpty {
                    self.showAddFileNumberPlaceholder()
                } else {
                    self.showChooseFileNumberPlaceholder()
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
        let cell = tableView.dequeueReusableCell(withIdentifier:  REUSE_IDENTIFIER, for: indexPath) as! FileNumberTableViewCell
        
        let fileNumber = fileNumbers[indexPath.row]
        
        cell.fileNumberLabel.text = "File Number: \(fileNumber.assignedFileNumber)"
        cell.offenseLabel.text = (fileNumber.offense != "") ? "Offense: \(fileNumber.offense)" : "Offense: None"
        cell.bondLabel.text = "Bond: \(fileNumber.bond)"
        cell.continuancesLabel.text = "Continuances: \(fileNumber.continuances)"
        
        self.tableView.backgroundColor = UIColor(red: 118/255, green: 197/255, blue: 142/255, alpha: 1)
        
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
        
        if fileNumbers.isEmpty {
            showAddFileNumberPlaceholder()
        }
    }
    
    //MARK: Segues
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TAB_SEGUE, sender: self)
    }
    
    //Load the details for the selected file number
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as? UITabBarController
        
        let clientDetailsNavBarController = tabBarController?.viewControllers?[0] as? UINavigationController
        let caseDetailsNavBarController = tabBarController?.viewControllers?[1] as? UINavigationController
        let documentsNavBarController = tabBarController?.viewControllers?[2] as? UINavigationController
        let feeApplicationNavBarController = tabBarController?.viewControllers?[3] as? UINavigationController
        
        let destinationClientDetailsVC = clientDetailsNavBarController?.topViewController as? ClientDetailsVC
        let destinationCaseDetailsVC = caseDetailsNavBarController?.topViewController as? CaseDetailsVC
        let destinationDocumentCollectionVC = documentsNavBarController?.topViewController as? DocumentCollectionVC
        let destinationFeeApplicationVC = feeApplicationNavBarController?.topViewController as? FeeApplicationVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationClientDetailsVC?.selectedClient = selectedClient
            destinationClientDetailsVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationCaseDetailsVC?.selectedClient = selectedClient
            destinationCaseDetailsVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationDocumentCollectionVC?.selectedClient = selectedClient
            destinationDocumentCollectionVC?.selectedFileNumber = fileNumbers[indexPath.row]
            
            destinationFeeApplicationVC?.selectedClient = selectedClient
            destinationFeeApplicationVC?.selectedFileNumber = fileNumbers[indexPath.row]
        }
    }
    
}
