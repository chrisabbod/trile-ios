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
}
