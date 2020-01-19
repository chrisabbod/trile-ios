//
//  OffenseTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class OffenseTableVC: UITableViewController {
    
    var offenses: [Offense] = []
    var filteredOffenses: [Offense] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        offenses = Offense.offenses()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Offenses"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if isFiltering {
        return filteredOffenses.count
      }
        
      return offenses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let offense: Offense
        if isFiltering {
            offense = filteredOffenses[indexPath.row]
        } else {
            offense = offenses[indexPath.row]
        }
        
        cell.textLabel?.text = offense.name
        cell.detailTextLabel?.text = offense.category.rawValue
        
        return cell
    }
    
    
    func filterContentForSearchText(_ searchText: String, category: Offense.Category? = nil) {
        filteredOffenses = offenses.filter { (offense: Offense) -> Bool in
            return offense.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }

}

extension OffenseTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
