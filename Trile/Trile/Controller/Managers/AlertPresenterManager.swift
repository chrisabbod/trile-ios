//
//  AlertPresenterManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/14/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class AlertPresenterManager {
    
    let SHOW_CHOOSE_CLIENT_PLACEHOLDER = "showChooseClientPlaceholder"
    let SHOW_CHOOSE_FILE_NUMBER_PLACEHOLDER = "showChooseFileNumberPlaceholder"

    let dbm = FirebaseFirestoreManager()
    let imageManager = FirebaseStorageManager()
    
    //MARK: Onboarding
    
    func messageAlertDialog(fromViewController vc: UIViewController, withTitle title: String, withMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        
        alert.addAction(dismissAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Add Client
    
    func addClientAlertDialog(fromViewController vc: UIViewController, completion: @escaping ((_ clientArray: [Client], _ success: Bool) -> Void)) {
        
        var firstNameTextField = UITextField()
        var lastNameTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Client", message: "Enter Client Name", preferredStyle: .alert)
        let addClientAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newClient = Client()
            
            if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
                newClient.firstName = firstName
                newClient.lastName = lastName
                
                self.dbm.addClientToDatabase(newClient)
                self.dbm.readClientsFromDatabase(completion: { (clientArray, success) in
                    if success {
                        
                        //Calls Notification Function in ClientTableVC to show placeholder
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.SHOW_CHOOSE_CLIENT_PLACEHOLDER), object: nil)
                        
                        completion(clientArray, true)
                    } else {
                        print("Unable to read client data from database")
                    }
                })
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("No client added")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addClientAction)
        alert.addTextField { (field) in
            firstNameTextField = field
            field.placeholder = "First Name"
        }
        alert.addTextField { (field) in
            lastNameTextField = field
            field.placeholder = "Last Name"
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Add File Number
        
    func addFileNumberAlertDialog(fromViewController vc : UIViewController, withClient client: Client, completion: @escaping ((_ fileNumberArray: [FileNumber], _ success: Bool) -> Void)) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New File Number", message: "Enter File Number", preferredStyle: .alert)
        let addFileNumberAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newFileNumber = FileNumber()
            
            if let newAssignedFileNumber = textField.text {
                newFileNumber.assignedFileNumber = newAssignedFileNumber
                
                self.dbm.addFileNumberToDatabase(client, newFileNumber)
                self.dbm.readFileNumbersFromDatabase(client) { (fileNumberArray, success) in
                    if success {
                        
                        //Calls Notification Function in FileNumberTableVC to show placeholder
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.SHOW_CHOOSE_FILE_NUMBER_PLACEHOLDER), object: nil)
                        
                        completion(fileNumberArray, true)
                    } else {
                        print("Unable to read file number data from database")
                    }
                }
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
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func deleteDocumentAlertDialog(vc : UIViewController, client: Client, fileNumber: FileNumber, documents: [Document], indexPath: IndexPath, completion: @escaping ((_ success: Bool) -> Void)) {
        
        let alert = UIAlertController(title: "Delete Document", message: "Would you like to delete this document?", preferredStyle: .alert)
        let deleteDocumentAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.imageManager.deleteDocumentFromStorage(documents, indexPath) { (success) in
                if success {
                    self.dbm.deleteDocumentFromDatabase(client, fileNumber, documents, indexPath)
                    completion(true)
                } else {
                    print("Unable to delete document from storage")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("No document deleted")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteDocumentAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
