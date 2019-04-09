//
//  ModelTest.swift
//  eLitTests
//
//  Created by Gianpaolo Di Pietro on 06/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import XCTest
@testable import eLit

class ModelTest: XCTestCase {
    
    let jsonString = ""
    var drinks: [Drink]?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        // XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        self.drinks = self.loadDrinks()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDataCreation() {
        let path = Bundle.main.path(forResource: "drinks", ofType: "txt")
        do {
            let drinkData = try String(contentsOfFile: path ?? "", encoding: .utf8)
            let drinkDict = self.fromJson(drinkData)
            let d = drinkDict["data"] as? [[String: Any]] ?? []
            
            var drinks: [Drink] = []
            for drink in d {
                let d = Drink(dict: drink)
                drinks.append(d)
            }
            
            XCTAssert(drinks.count == d.count)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testDrink() {
        guard let drinks = self.drinks else {
            XCTAssertTrue(false)
            return
        }
        
        for drink in drinks {
            let components = drink.components()
            var acc = 0.0
            for component in components {
                if component.qty == 0 {
                    XCTAssertEqual(component.unit, "SOME")
                }
                acc = acc + component.qty
            }
            
            var recipeSteps: [RecipeStep] = []
            var realComponents: [DrinkComponent] = []
            var realIngredients: [Ingredient] = []
            
            for steps in drink.drinkRecipe?.steps?.array as? [RecipeStep] ?? [] {
                recipeSteps.append(steps)
            }
            for step in recipeSteps {
                realComponents.append(contentsOf: step.withComponents?.array as? [DrinkComponent] ?? [])
            }
            
            realIngredients += realComponents.map({$0.withIngredient!})
            
            for ing in drink.ingredients() {
                XCTAssertTrue(realIngredients.contains(ing))
            }
            
            let realAcc = realComponents.map({$0.qty}).reduce(0, +)
            XCTAssertEqual(realAcc, acc)
        }
    }
    
    private func fromJson(_ stringData: String) -> [String: Any] {
        guard let jsonData = stringData.data(using: .utf8) else { return [:] }
        
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData)
            let dictData = json as? [String: Any] ?? [:]
            return dictData
        } catch {
            return [:]
        }
    }
    
    private func loadDrinks() -> [Drink]? {
        let path = Bundle.main.path(forResource: "drinks", ofType: "txt")
        do {
            let drinkData = try String(contentsOfFile: path ?? "", encoding: .utf8)
            let drinkDict = self.fromJson(drinkData)
            let d = drinkDict["data"] as? [[String: Any]] ?? []
            
            var drinks: [Drink] = []
            for drink in d {
                let d = Drink(dict: drink)
                drinks.append(d)
            }
            return drinks
        } catch {
            XCTAssertTrue(false)
            return nil
        }
    }
    
}
