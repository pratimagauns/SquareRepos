//
//  DataRepository.swift
//  SquareRepos
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation

//
// Singleton class that forms the Data abstraction.
// Responsible for providing the data to the UI layer - either from API or persistent storage
//
class DataManager {
    let service:Service
    
    let url = "https://api.github.com/orgs/square/repos"
    
    init(service: Service) {
        self.service = service
    }
    
    func fetch(response: @escaping ([Repository]?, APIError?) -> Void) {
        self.service.request(from: url) { (result) in
            switch result {
            case .success(let returnJson) :
                let repositories = returnJson.arrayValue.compactMap {return Repository(data: try! $0.rawData())}
                response(repositories, nil)
            case .failure(let failure) :
                response(nil, failure)
            }
        }
    }
}

extension DataManager {
    
    private static var _shared: DataManager?
    
    public static let shared: DataManager = {
        guard let instance = _shared else {
            return DataManager(service: DataService())
        }
        return instance
    }()
    
    public class func initializeShared(_ instance: DataManager) {
        _shared = instance
    }
}
