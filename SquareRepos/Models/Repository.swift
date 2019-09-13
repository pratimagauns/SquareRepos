//
//  Repository.swift
//  SquareRepos
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case description
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

