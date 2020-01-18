//
//  OffenseTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class OffenseTableVC: UITableViewController, UISearchResultsUpdating {

    let tableData = ["One","Two","Three","Twenty-One"]
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            //controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()

        // Reload the table
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]

        self.tableView.reloadData()
    }
    
    // MARK: Table view data source

     override func numberOfSections(in tableView: UITableView) -> Int {
       // 1
       // return the number of sections
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // 2
      // return the number of rows
      if  (resultSearchController.isActive) {
          return filteredTableData.count
      } else {
          return tableData.count
      }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // 3
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

      if (resultSearchController.isActive) {
          cell.textLabel?.text = filteredTableData[indexPath.row]

          return cell
      }
      else {
          cell.textLabel?.text = tableData[indexPath.row]
          print(tableData[indexPath.row])
          return cell
      }
    }
    
}
