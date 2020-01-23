//
//  OffenseTableVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class OffenseTableVC: UITableViewController {
    
    let NOTIFICATION_VALUE = "loadFileNumberTableVC"
    
    var db = Firestore.firestore()
    let uid: String = Auth.auth().currentUser!.uid
    
    let dbm = FirebaseFirestoreManager()
    
    var selectedClient: Client?
    var selectedFileNumber: FileNumber?
    
    var offenses: [Offense] = []
    var filteredOffenses: [Offense] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var offenseClicked = false
    var otherOffenseClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offenses = Offense.offenses()
        
        searchController.searchBar.scopeButtonTitles = Offense.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Offenses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        print("Offense Clicked: \(offenseClicked)")
        print("Other Offense Clicked: \(otherOffenseClicked)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Calls Notification Function in FileNumberTableVC to reload data
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VALUE), object: nil)
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let caseData: [String: Any]
        
        if !isFiltering {
            let name = offenses[indexPath.row].name
            var category = offenses[indexPath.row].category.rawValue
            var offenseClass = offenses[indexPath.row].offenseClass.rawValue
            let trafficType = offenses[indexPath.row].trafficType.rawValue
            
            if offenseClicked {
                switch offenseClass {
                case "One":
                    offenseClass = "1"
                case "Two":
                    offenseClass = "2"
                case "Three":
                    offenseClass = "3"
                default:
                    print("No issues")
                }
                
                if category == "Probation" {
                    category = "Misdemeanor Probation Violation"
                }
                
                caseData = [
                    "offense": name,
                    "offense_category": category,
                    "offense_class": offenseClass,
                    "offense_traffic_type": trafficType
                ]
            } else {
                caseData = ["other_offense": name]
            }

        } else {
            let filteredName = filteredOffenses[indexPath.row].name
            var filteredCategory = filteredOffenses[indexPath.row].category.rawValue
            var filteredOffenseClass = filteredOffenses[indexPath.row].offenseClass.rawValue
            let filteredTrafficType = filteredOffenses[indexPath.row].trafficType.rawValue
            
            if offenseClicked {
                switch filteredOffenseClass {
                case "One":
                    filteredOffenseClass = "1"
                case "Two":
                    filteredOffenseClass = "2"
                case "Three":
                    filteredOffenseClass = "3"
                default:
                    print("No issues")
                }
                
                if filteredCategory == "Probation" {
                    filteredCategory = "Misdemeanor Probation Violation"
                }
                            
                caseData = [
                    "offense": filteredName,
                    "offense_category": filteredCategory,
                    "offense_class": filteredOffenseClass,
                    "offense_traffic_type": filteredTrafficType
                ]
            } else {
                caseData = ["other_offense": filteredName]
            }

        }
        
        if let client = selectedClient, let fileNumber = selectedFileNumber {
            dbm.addCaseDataToDatabase(client, fileNumber, caseData)
        }
        
        performReturnSegue()
    }
    
    //MARK: Filter Content Function
    
    func filterContentForSearchText(_ searchText: String, category: Offense.Category? = nil) {
        filteredOffenses = offenses.filter { (offense: Offense) -> Bool in
            let doesCategoryMatch = category == .all || offense.category == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && offense.name.lowercased()
                    .contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}

//MARK: Search Results Update Extension

extension OffenseTableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Offense.Category(rawValue:
            searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: category)
    }
    
}

//MARK: Search Bar Scope Extension

extension OffenseTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Offense.Category(rawValue:
            searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension UIViewController {
    func performReturnSegue()  {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
