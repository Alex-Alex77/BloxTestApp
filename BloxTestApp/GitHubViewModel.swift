//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class GitHubViewModel: NSObject {

    // MARK: Public

    var repositories: [Repository] = []
    var updateList: (() -> Void)?

    // MARK: Private

    private let apiService: GitHubApiService

    // MARK: Initialization

    init(apiService: GitHubApiService = GitHubApiService()) {
        self.apiService = apiService
    }
}

// MARK: UITableViewDataSource

extension GitHubViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = repositories[indexPath.row]
        let cell: RepositoryCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = RepositoryCellViewModel(name: repository.name, url: repository.url)
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: UITableViewDelegate

extension GitHubViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UISearchBarDelegate

extension GitHubViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        apiService.loadItems(GitHubRouter.search(text)) { result in
            switch result {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print("Error:", error)
                self.repositories.removeAll()
            }
            self.updateList?()
        }
    }
}
