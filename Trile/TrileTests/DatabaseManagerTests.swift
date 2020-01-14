//
//  DatabaseManagerTests.swift
//  TrileTests
//
//  Created by Chris Abbod on 1/14/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import Trile

class DatabaseManagerTests: XCTestCase {

    var sut: DatabaseManager!
    
    var db = Firestore.firestore()
    
    override func setUp() {
        super.setUp()
        sut = DatabaseManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAddClientToDatabaseAddsClientToDatabase() {
        //when
        let newClient = Client()
        let testUID = "test_uid"
        let clientRef = db.collection("users").document(testUID).collection("clients")
        let newID = clientRef.document().documentID
        newClient.documentID = newID

        //given
        newClient.name = "Test Client"
        sut.addClientToDatabase(newClient)
        
        //then
        
        //XCTAssertEqual(, "Test Client")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
