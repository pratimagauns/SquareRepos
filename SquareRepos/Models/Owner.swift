//
//  Owner.swift
//  SquareRepos
//
//  Created by Pratima Gauns on 9/16/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation

struct Owner: Codable {
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}

extension Owner {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Owner.self, from: data)
            self = me
        }
        catch {
            print(error)
            return nil
        }
    }
}
