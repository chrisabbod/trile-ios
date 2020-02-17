//
//  Client.swift
//  Trile
//
//  Created by Chris Abbod on 12/26/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import Foundation

class Client {
    var documentID: String = ""  //ID given to document generated by firestore database
    
    var imageUUID: String = ""
    var imagePath: String = ""
    var imageData: Data = Data()
    
    var fullName: String = ""
    var firstName: String = ""
    var middleName: String = ""
    var lastName: String = ""
    var age: Int = 0
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    
    var placeOfEmployment: String = ""
    var role: String = ""
    var dateStarted: String = ""
    var dateEnded: String = ""
    var incomeRange: String = ""
    
    var totalChildren: String = ""
    var totalOtherOccupants: String = ""
}
