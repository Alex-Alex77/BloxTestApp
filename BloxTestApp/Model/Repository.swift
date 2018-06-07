//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, owner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let owner = try container.decode(Owner.self, forKey: .owner)
        url = owner.url
    }

    private struct Owner: Codable {
        let url: String
    }
}
