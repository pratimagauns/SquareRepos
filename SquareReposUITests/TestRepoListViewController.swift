//
//  TestRepoListView.swift
//  SquareReposUITests
//
//  Created by Pratima on 13/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import XCTest
@testable import SquareRepos

struct MockService: Service {
    func request(from: String, completion: @escaping CompletionHandler) {
        completion(APIResult.success("[{\"id\":230958,\"name\":\"html5\",\"full_name\":\"square html5\",\"description\":\"A Rails plugin for playing around with HTML5.\"}]"))
    }
}

class TestRepoListViewController: XCTestCase {
    var app: XCUIApplication!
    var repoViewModel:RepoViewModel!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        let dataService = MockService()
        repoViewModel = RepoViewModel(dataManager: DataManager(service: dataService))
    }
    
    func testSuccessData() {
        //For success scenario wait until first element is shown
        let label = app.staticTexts["html5"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 0.5) { (error) in
            XCTAssert(true, "Repo list load failed")
        }
    }
}
