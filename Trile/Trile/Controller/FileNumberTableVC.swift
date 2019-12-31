//
//  FileNumberTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 12/31/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import UIKit

class FileNumberTableVC: UITableViewController {

    let TAB_SEGUE = "goToTabVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addFileNumberButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFileNumberAlertDialog(_:)))
        navigationItem.rightBarButtonItem = addFileNumberButton
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
    
    //MARK: - Alert Dialog
    
    @objc
    func addFileNumberAlertDialog(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New File Number", message: "Enter File Number", preferredStyle: .alert)
        let addFileNumberAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let name = textField.text {
//                self.addClientToDatabase(name)
//                self.readClientsFromDatabase()
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
