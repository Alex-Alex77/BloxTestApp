//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import Alamofire

protocol GitHubApiServiceType {
    func loadItems(_ urlRequest: URLRequestConvertible, onCompletion: @escaping (UIViewController.ItemsResult) -> Void)
}

struct RepositoriesResponse: Codable {
    let items: [Repository]
    let incompleteResults: Bool
    let totalCount: Int
}

struct ErrorResponse: Error, Codable {
    let message: String
    let documentationUrl: URL
}

extension ErrorResponse: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString("Couldn't complete your request, try to change searched text", comment: "Response error")
    }
}

final class GitHubApiService: GitHubApiServiceType {
    var currentRequest: DataRequest?

    func loadItems(_ urlRequest: URLRequestConvertible, onCompletion: @escaping (UIViewController.ItemsResult) -> Void) {

        func fireErrorCompletion(_ error: Error?) {
            onCompletion(UIViewController.ItemsResult(items: nil, error: error, currentPage: 0, pageCount: 0))
        }

        currentRequest?.cancel()

        currentRequest = Alamofire.request(urlRequest).responseData { response in
            if let error = response.error {
                guard (error as NSError).code != NSURLErrorCancelled else {
                    return
                }
                print(error)
                fireErrorCompletion(error)
                return
            }

            guard let data = response.result.value else {
                guard let error = response.error else {
                    return
                }
                print(error)
                fireErrorCompletion(error)
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                print(error)
                fireErrorCompletion(error)
                return
            }

            do {
                let result = try decoder.decode(RepositoriesResponse.self, from: data)
                let repositoriesResult = UIViewController.ItemsResult(
                    items: result.items,
                    error: nil,
                    currentPage: 1, //result.incompleteResults,
                    pageCount: result.totalCount)
                onCompletion(repositoriesResult)
            } catch {
                print(error)
                fireErrorCompletion(error)
            }
        }
    }
}
