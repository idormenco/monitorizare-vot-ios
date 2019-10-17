//
//  APITests.swift
//  MonitorizareVotTests
//
//  Created by Cristi Habliuc on 17/10/2019.
//  Copyright © 2019 Code4Ro. All rights reserved.
//

import XCTest
@testable import MonitorizareVot

class APITests: XCTestCase {
    
    let correctPhone = "0722445566"
    let correctPin = "389756"

    var sut: APIManagerType?

    override func setUp() {
        sut = APIManager.shared
    }

    override func tearDown() {
        sut = nil
    }
    
    func testLogin() {
        let knownPhone = correctPhone
        let knownPin = correctPin
        var waiter = expectation(description: "Successful Login")
        sut?.login(withPhone: knownPhone, pin: knownPin, then: { error in
            XCTAssertNil(error)
            waiter.fulfill()
        })
        
        wait(for: [waiter], timeout: 10)
        
        let wrongPhone = "0722777889"
        let wrongPin = "12849"
        waiter = expectation(description: "Unsuccessful Login")
        sut?.login(withPhone: wrongPhone, pin: wrongPin, then: { error in
            XCTAssertNotNil(error)
            waiter.fulfill()
        })
        
        wait(for: [waiter], timeout: 10)
    }

    func testGetPollingStations() {
        let knownPhone = correctPhone
        let knownPin = correctPin
        let waiter = expectation(description: "Polling Stations")
        sut?.login(withPhone: knownPhone, pin: knownPin, then: { error in
            self.sut?.fetchPollingStations(then: { (stations, error) in
                XCTAssertNil(error)
                waiter.fulfill()
            })
        })
        
        wait(for: [waiter], timeout: 10)
    }

}
