//
//  SquareReposUITests.swift
//  SquareReposUITests
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import XCTest

class SquareReposUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessRepoListLoad(){
        
        //Check if table loaded
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.count != 0, "No List shown")
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: tablesQuery.cells.staticTexts["html5"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil) //Will pass if internet is connected
        
        //Check of on item click, webview is shown
        tablesQuery.staticTexts["html5"].tap()
        let webView = app.otherElements["RepoDetails"].children(matching: .webView).element
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: webView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
