//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com/"

    case search(String)

    var method: HTTPMethod {
        switch self {
        case .search: return .get
        }
    }

    var url: URL {
        let relativePath: String
        switch self {
        case .search:
            relativePath = "search/repositories"
        }

        var url = URL(string: GitHubRouter.baseURLString)!
        url.appendPathComponent(relativePath)
        return url
    }

    var parameters: [String: Any]? {
        switch self {
        case .search(let query):
            return ["q": query]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let encoding: ParameterEncoding

        switch method {
        case .get:
            encoding = URLEncoding.default
        case .post:
            encoding = JSONEncoding.default
        default:
            return urlRequest
        }

        return try encoding.encode(urlRequest, with: parameters)
    }
}
