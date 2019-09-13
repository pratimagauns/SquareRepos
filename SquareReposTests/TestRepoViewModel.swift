//
//  TestRepoViewModel.swift
//  SquareReposTests
//
//  Created by Pratima on 13/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import SquareRepos

class TestRepoViewModel: XCTestCase {
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessData() {
        let dataService = MockDataService()
        let repoViewModel = RepoViewModel(dataManager: DataManager(service: dataService))
        repoViewModel
            .repositories
            .subscribe({ (result) in
                XCTAssertNil(result, "Data fetch failure")
                XCTAssertEqual(result.element![0].name, "html5", "Data fetch failure")
            })
            .disposed(by: disposeBag)
        repoViewModel.requestData()
    }
    
    func testNoInternet() {
        let dataService = MockDataServiceNetWorkError()
        let repoViewModel = RepoViewModel(dataManager: DataManager(service: dataService))
        repoViewModel
            .error
            .subscribe({ (result) in
                XCTAssertEqual(result.element, "No network Connection.", "No network Connection error failure")
            })
            .disposed(by: disposeBag)
        repoViewModel.requestData()
    }
    
    func testServiceError() {
        let dataService = MockDataServiceError()
        let repoViewModel = RepoViewModel(dataManager: DataManager(service: dataService))
        repoViewModel
            .error
            .subscribe({ (result) in
                XCTAssertEqual(result.element, "Error occurred while fetching data. Please try later.", "Service error failure")
            })
            .disposed(by: disposeBag)
        repoViewModel.requestData()
    }
}
