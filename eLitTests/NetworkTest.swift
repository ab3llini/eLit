//
//  NetworkTest.swift
//  eLitTests
//
//  Created by Gianpaolo Di Pietro on 13/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import XCTest
@testable import eLit

class NetworkTest: XCTestCase {
    var dbm: DataBaseManager!
    var model: Model!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dbm = DataBaseManager.shared
        self.model = Model.shared
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchData() {
        let promise = expectation(description: "Simple Request")
        self.dbm.fetchAllData(completion: {response in
            XCTAssertNotEqual(response["status"] as! String, "ERROR")
            guard let data = response["data"] as? [[String: Any]] else {
                XCTAssertTrue(false)
                return
            }
            
            var drinks: [Drink] = []
            for d in data {
                drinks.append(Drink(dict: d))
            }
            XCTAssertGreaterThan(drinks.count, 0)
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
    }
    
    func testUpdateData() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
