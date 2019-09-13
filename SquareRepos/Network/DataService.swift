//
//  DataService.swift
//  SquareRepos
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Service {
    typealias CompletionHandler = (APIResult)->Void
    func request(from: String, completion: @escaping CompletionHandler)
}

enum APIResult {
    case success(JSON)
    case failure(APIError)
}

enum APIError: Error {
    case unknownError
    case connectionError
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
}

struct DataService: Service {
    func request(from: String, completion: @escaping CompletionHandler) {
        guard let url = URL(string: from) else {
            completion(APIResult.failure(.notFound))
            return
        }
        
        let urlSession = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let _ = error {
                completion(APIResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
                    switch responseCode.statusCode {
                    case 200:
                        completion(APIResult.success(responseJson))
                    case 500...599:
                        completion(APIResult.failure(.serverError))
                    default:
                        completion(APIResult.failure(.unknownError))
                        break
                    }
                }
                catch _ {
                    completion(APIResult.failure(.unknownError))
                }
            }
        }
        urlSession.resume()
    }
}
