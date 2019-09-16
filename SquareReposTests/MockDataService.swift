//
//  MockDataService.swift
//  SquareReposTests
//
//  Created by Pratima on 13/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import SquareRepos

struct MockDataServiceNoData: Service {

    func request(from: String, completion: @escaping CompletionHandler) {
        completion(APIResult.success("{}"))
    }
}

struct MockDataServiceNetWorkError: Service {

    func request(from: String, completion: @escaping CompletionHandler) {
        completion(APIResult.failure(.connectionError))
    }
}

struct MockDataServiceError: Service {

    func request(from: String, completion: @escaping CompletionHandler) {
        completion(APIResult.failure(.serverUnavailable))
    }
}

struct MockDataService: Service {
    
    func request(from: String, completion: @escaping CompletionHandler) {
        let string = "[{\"id\":230958,\"name\":\"html5\",\"full_name\":\"square html5\",\"description\":\"A Rails plugin for playing around with HTML5.\"}]"
        completion(APIResult.success(JSON(string.data(using: .utf8)!)))
    }
}
