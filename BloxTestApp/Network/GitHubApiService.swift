//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import Alamofire

protocol ApiServiceType {
    associatedtype T
    func loadItems(_ urlRequest: URLRequestConvertible, completionHandler: @escaping (Result<[T]>) -> Void)
}

enum GitHubAPIServiceError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case objectSerialization(reason: String)
}

final class GitHubApiService {
    private var currentRequest: DataRequest?
}

extension GitHubApiService: ApiServiceType {
    func loadItems(_ urlRequest: URLRequestConvertible,
                   completionHandler: @escaping (Result<[Repository]>) -> Void) {

        // Cancel previous request if there is one
        if let currentRequest = currentRequest {
            currentRequest.cancel()
            self.currentRequest = nil
        }

        currentRequest = Alamofire.request(urlRequest)
            .responseJSON(queue: .global(qos: .userInitiated)) { response in
                let result = self.repositoriesFromResponse(response: response)
                self.currentRequest = nil
                DispatchQueue.main.async {
                    completionHandler(result)
                }
        }
    }

    private func repositoriesFromResponse(response: DataResponse<Any>) -> Result<[Repository]> {
        if let error = response.result.error {
            print(error)
            return .failure(GitHubAPIServiceError.network(error: error))
        }

        // Check if we have JSON in response
        guard let jsonDictionary = response.result.value as? [String: Any] else {
            let reason = "Didn't get response as JSON from API"
            print("Error:", reason)
            return .failure(GitHubAPIServiceError.apiProvidedError(reason: reason))
        }

        // Check for "message" errors in the JSON because this API does that
        if let errorMessage = jsonDictionary["message"] as? String {
            print("Error:", errorMessage)
            return .failure(GitHubAPIServiceError.apiProvidedError(reason: errorMessage))
        }

        // Check we got repositories in JSON
        guard let items = jsonDictionary["items"] as? [[String: Any]] else {
            let reason = "Didn't get an array of repositories from JSON"
            print("Error:", reason)
            return .failure(GitHubAPIServiceError.objectSerialization(reason: reason))
        }

        // Using new API from Swift 4 to parse objects from data
        do {
            let data = try JSONSerialization.data(withJSONObject: items, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let repositories = try decoder.decode([Repository].self, from: data)
            return .success(repositories)
        } catch {
            return .failure(error)
        }
    }
}
