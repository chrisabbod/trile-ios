//
//  OffenseTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class OffenseTableVC: UITableViewController {
    
    
    
//
//    let tableData = PickerListManager.offenseDictList
//    let offenseList: [String] = PickerListManager.offenseDictList.map({$0.key})
//
//    var filteredTableData = [String]()
//    var resultSearchController = UISearchController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        resultSearchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self
//            //controller.obscuresBackgroundDuringPresentation = false
//            controller.searchBar.sizeToFit()
//
//            tableView.tableHeaderView = controller.searchBar
//
//            return controller
//        })()
//
//        tableView.reloadData()
//
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        filteredTableData.removeAll(keepingCapacity: false)
//
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let offenseArray = (offenseList as NSArray).filtered(using: searchPredicate)
//
//        filteredTableData = offenseArray as! [String]
//
//        self.tableView.reloadData()
//    }
//
//    // MARK: Table View Functions
//
//     override func numberOfSections(in tableView: UITableView) -> Int {
//       return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//      if  (resultSearchController.isActive) {
//          return filteredTableData.count
//      } else {
//          return tableData.count
//      }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//      if (resultSearchController.isActive) {
//          cell.textLabel?.text = filteredTableData[indexPath.row]
//
//          return cell
//      }
//      else {
//          cell.textLabel?.text = offenseList[indexPath.row]
//          return cell
//      }
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentCell = tableView.cellForRow(at: indexPath)!
//
//        print(currentCell.textLabel!.text!)
////        let clickedCell = currentCell
////        print(clickedCell.textLabel!.text!)
//    }
//
}
