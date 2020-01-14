//
//  AlertPresenterManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/14/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class AlertPresenterManager {
    
    let dbm = DatabaseManager()
    
    func addClientAlertDialog(fromViewController vc : UITableViewController, completion: @escaping ((_ clientArray: [Client], _ success: Bool) -> Void)) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Client", message: "Enter Client Name", preferredStyle: .alert)
        let addClientAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newClient = Client()
            
            if let name = textField.text {
                newClient.name = name
                
                self.dbm.addClientToDatabase(newClient)
                self.dbm.readClientsFromDatabase(completion: { (clientArray, success) in
                    if success {
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
            textField = field
            field.placeholder = "Enter Client Name"
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
}
