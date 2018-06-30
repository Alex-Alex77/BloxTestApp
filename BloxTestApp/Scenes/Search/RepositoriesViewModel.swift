//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {
    func update(response: UIViewController.ItemsResult)
}

final class RepositoriesViewModel {

    weak var delegate: SearchViewModelDelegate?

    private let apiService: GitHubApiServiceType

    // MARK: Initialization

    init(apiService: GitHubApiServiceType = GitHubApiService()) {
        self.apiService = apiService
    }

    func load(query: String, page: Int) {
        apiService.loadItems(GitHubRouter.search(query, page: page)) { [delegate] response in
            delegate?.update(response: response)
        }
    }
}
