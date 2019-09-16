//
//  Repository.swift
//  SquareRepos
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation

// 
// Repository Model
// 
struct Repository: Codable {
    let id: Int
    let name: String
    let description: String?
    let htmlUrl: String?
    let owner: Owner?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case owner
        case htmlUrl = "html_url"
    }
}

extension Repository {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Repository.self, from: data)
            self = me
        }
        catch {
            print(error)
            return nil
        }
    }
}

