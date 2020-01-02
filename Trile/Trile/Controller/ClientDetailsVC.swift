//
//  ClientDetailsVC.swift
//  Trile
//
//  Created by Chris Abbod on 1/1/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class ClientDetailsVC: UIViewController {
    
    @IBOutlet weak var clientPictureImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    let EDIT_CLIENT_DETAILS_SEGUE = "goToEditClientDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        
        self.navigationItem.rightBarButtonItem = signOutButton
        
        //        circularImage.layer.masksToBounds = true
        //        circularImage.layer.cornerRadius = circularImage.bounds.width / 2
    }
    
    @IBAction func editClientDetailsButton(_ sender: Any) {
        performSegue(withIdentifier: EDIT_CLIENT_DETAILS_SEGUE, sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! FileNumberTableVC
//
//        if let indexPath = tableView.indexPathForSelectedRow{
//            destinationVC.selectedClient = clients[indexPath.row]
//        }
    }
    
    func transitionToHome() {
        
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController")
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
    
    //MARK: - Bar Buttons
    
    @objc
    func signOut(_ sender: UIBarButtonItem) {
        transitionToHome()
    }
    

}
