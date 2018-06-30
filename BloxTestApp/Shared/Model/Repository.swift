//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import Foundation

struct Owner: Codable {
    let url: URL
}

struct Repository: Codable {
    let name: String
    let owner: Owner
}
