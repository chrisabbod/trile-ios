//
//  ClientDetailSplitVC.swift
//  Trile
//
//  Created by Chris Abbod on 2/26/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class ClientDetailSplitVC: UISplitViewController {

    let PLACEHOLDER_VC_IDENTIFIER = "PlaceholderVC"

    var dbm = FirebaseFirestoreManager()

    var clients = [Client]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClients { (success) in
            if success {
                if self.clients.isEmpty {
                    print("Clients Empty")
                    self.showAddClientPlaceholder()
                } else {
                    print("Clients Not Empty")
                    self.showChooseClientPlaceholder()
                }
            }
        }
    }
    
    //MARK: Load Clients
    
    func loadClients(completion: @escaping (_ success: Bool) -> Void) {
        dbm.readClientsFromDatabase(completion: { (clientArray, success) in
            if success {
                self.clients = clientArray
                completion(true)
            } else {
                completion(false)
            }
        })
    }

    //MARK: Show Placeholder Functions
    
    @objc
    func showAddClientPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.addClient = true
        print("ADD CLIENT")
        self.showDetailViewController(placeholderVC, sender: self)
    }
    
    @objc
    func showChooseClientPlaceholder() {
        let placeholderVC = PlaceholderVC(nibName: PLACEHOLDER_VC_IDENTIFIER, bundle: nil)
        placeholderVC.chooseClient = true
        print("CHOOSE CLIENT")
        self.showDetailViewController(placeholderVC, sender: self)
    }
}
