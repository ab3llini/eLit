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
    var em: EntityManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dbm = DataBaseManager.shared
        self.model = Model.shared
        self.em = EntityManager.shared
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
        let promise = expectation(description: "Update")
        let objects = self.em.fetchAll(type: DrinkObject.self) ?? []
        for o in objects {
            o.fingerprint = "000"
        }
        model.savePersistentModel()
        
        self.dbm.updateDB(completion: {response in
            let num = self.model.getDrinks().count
            self.dbm.defaultUdateDbHandler(response)
            XCTAssertGreaterThanOrEqual(self.model.getDrinks().count, num)
            let drinks = self.em.fetchAll(type: Drink.self) ?? []
            let categories = self.em.fetchAll(type: DrinkCategory.self) ?? []
            let ingredients = self.em.fetchAll(type: Ingredient.self) ?? []
            
            for drink in drinks {
                //XCTAssertEqual(drinks.filter({$0.name == drink.name}).count, 1)
            }
            for category in categories {
                XCTAssertEqual(categories.filter({$0.name == category.name}).count, 1)
            }
            for ingredient in ingredients {
                XCTAssertEqual(ingredients.filter({$0.name == ingredient.name}).count, 1)
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 100)
    }
    
    func testFetchReviews() {
        var promises: [XCTestExpectation] = []
        var revs: [Review] = []
        for drink in model.getDrinks() {
            promises.append(expectation(description: drink.name!))
            self.dbm.requestReviews(for: drink, from: 0, completion: {response in
                XCTAssertNotEqual(response["status"] as! String, "ERROR")
                let reviews = response["data"] as? [[String: Any]] ?? []
                
                for review in reviews {
                    let review = Review(
                        author : review["author"] as! String,
                        rating: review["rating"] as! Double,
                        title: review["title"] as! String,
                        text: review["text"] as! String,
                        timestamp: review["timestamp"] as! String
                    )
                    XCTAssertNotNil(review)
                    revs.append(review)
                }
                promises.first(where: {$0.description == drink.name!})?.fulfill()
            })
        }
        wait(for: promises, timeout: 30)
    }
    
    func testBarcode() {
        let barcode1 = "5010327755014"
        let barcode2 = "080480006891"
        let promise1 = expectation(description: barcode1)
        self.dbm.searchIngredient(for: barcode1, completion: { description in
            guard let desc = description else {
                promise1.fulfill()
                return
            }
            XCTAssertTrue(desc.lowercased().split(separator: " ").contains("gin"))
            promise1.fulfill()
        })
        wait(for: [promise1], timeout: 10)
        
        let promise2 = expectation(description: barcode2)
        self.dbm.searchIngredient(for: barcode2, completion: { description in
            guard let desc = description else {
                promise2.fulfill()
                return
            }
            XCTAssertTrue(desc.lowercased().split(separator: " ").contains("rum"))
            promise2.fulfill()
        })
        wait(for: [promise2], timeout: 10)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
