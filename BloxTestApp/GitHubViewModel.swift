//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

class GitHubViewModel: NSObject {
    var repositories: [Repository] = [
        Repository(name: "FirstName", url: "URL1"),
        Repository(name: "SecondName", url: "URL2")
    ]
}

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

extension GitHubViewModel: UITableViewDelegate {
}

extension GitHubViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("You're trying to find repository:", searchBar.text ?? "")
    }
}
