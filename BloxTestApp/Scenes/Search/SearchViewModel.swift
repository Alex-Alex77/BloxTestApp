//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class SearchViewModel: NSObject {

    // MARK: Public

    var repositories: [Repository] = []
    var updateList: ((Bool) -> Void)?

    // MARK: Private

    private let apiService: GitHubApiServiceType

    // MARK: Initialization

    init(apiService: GitHubApiServiceType = GitHubApiService()) {
        self.apiService = apiService
    }
}

// MARK: UITableViewDataSource

extension SearchViewModel: UITableViewDataSource {
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

extension SearchViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UISearchBarDelegate

extension SearchViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        apiService.loadItems(GitHubRouter.search(text)) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.updateList?(true)
            case .failure(let error):
                print("Error:", error)
                guard let error = error as? GitHubAPIServiceError, case .cancelled = error else {
                    self?.repositories.removeAll()
                    self?.updateList?(false)
                    return
                }
            }
        }
    }
}
