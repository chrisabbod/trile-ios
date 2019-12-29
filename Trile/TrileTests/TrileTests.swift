//
//  TrileTests.swift
//  TrileTests
//
//  Created by Chris Abbod on 12/26/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import XCTest
@testable import Trile

class TrileTests: XCTestCase {

    var sut: ClientTableVC!
    
    override func setUp() {
        super.setUp()
        sut = ClientTableVC()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInsertNewClientAddsClientWithNameProperty() {
        //when
        let clientOne = Client()
        let clientTwo = Client()
        let clientThree = Client()

        //given
        clientOne.name = "Client One"
        sut.insertNewClient(clientOne)

        clientTwo.name = "Client Two"
        sut.insertNewClient(clientTwo)

        clientThree.name = "Client Three"
        sut.insertNewClient(clientThree)
        
        //then
        XCTAssertEqual(3, sut.objects.count)
        XCTAssertEqual(sut.objects[0].name, "Client Three")
        XCTAssertEqual(sut.objects[1].name, "Client Two")
        XCTAssertEqual(sut.objects[2].name, "Client One")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
