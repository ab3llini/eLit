//
//  HomeTest.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import XCTest
@testable import eLit

class HomeTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSwitchTab() {
        let buttons = app.tabBars.children(matching: .button)
        for i in 0..<buttons.count {
            buttons.element(boundBy: i).tap()
        }
    }
    
    func testHomeView() {
        self.moveTo(tab: 0)
        self.app.swipeUp()
        self.app.swipeDown()
        
        let pagerView = app.tables.element.children(matching: .cell).element(boundBy: 0)
        pagerView.swipeLeft()
        pagerView.swipeLeft()
    }
    
    func testDrinkView() {
        self.moveTo(tab: 0)
        app.tables.children(matching: .cell).element(boundBy: 1).tap()
        app.navigationBars.children(matching: .button).element.tap()
        app.tables.children(matching: .cell).element(boundBy: 2).tap()
        app.navigationBars.children(matching: .button).element.tap()
        app.swipeUp()
    }
    
    func waitForElementToAppear(_ element: XCUIElement) -> Bool {
        let predicate = NSPredicate(format: "exists == 1")
        let promise = expectation(for: predicate, evaluatedWith: element,
                                  handler: nil)
        
        let result = XCTWaiter().wait(for: [promise], timeout: 10)
        return result == .completed
    }
    
    func moveTo(tab: Int) {
        let buttons = app.tabBars.children(matching: .button)
        let settingsButton = buttons.element(boundBy: tab)
        settingsButton.tap()
    }
    
}
