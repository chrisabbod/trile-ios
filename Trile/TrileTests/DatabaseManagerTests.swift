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

    var sut: FirebaseFirestoreManager!
    
    var db = Firestore.firestore()
    
    override func setUp() {
        super.setUp()
        sut = FirebaseFirestoreManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //TEST DOES NOT WORK. KEEPING FOR EXAMPLE
//    func testAddClientToDatabaseAddsClientToDatabase() {
//        //when
//        var testClients = [Client]()
//        let newClient = Client()
//
//        //given
//        newClient.name = "Test Client"
//        sut.addClientToDatabase(newClient)
//
//        sut.readClientsFromDatabase { (clientArray, success) in
//            if success {
//                testClients = clientArray
//
//            }
//        }
//
//        //then
//        XCTAssertEqual(testClients[0].name, "Test Client")
//    }
//
//    //TEST DOES NOT WORK. KEEPING FOR EXAMPLE
//    func testAddClientToDatabaseCanAddMultipleClientsToDatabase() {
//        //when
//        var testClients = [Client]()
//        let newClient = Client()
//        let testUser = "test_user"
//
//        let clientRef = db.collection("users").document(testUser).collection("clients")
//        let newID = clientRef.document().documentID
//        newClient.documentID = newID
//
//        //given
//        newClient.name = "Client One"
//        sut.addClientToDatabase(newClient)
//
//        newClient.name = "Client Two"
//        sut.addClientToDatabase(newClient)
//
//        newClient.name = "Client Three"
//        sut.addClientToDatabase(newClient)
//
//        sut.readClientsFromDatabase { (clientArray, success) in
//            if success {
//                testClients = clientArray
//            }
//        }
//
//        //then
//        XCTAssertEqual(testClients.count, 3)
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
