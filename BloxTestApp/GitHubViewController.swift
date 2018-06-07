//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class GitHubViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: ViewModel

    // Shoud be injected, but initialized here for simplicity
    private let viewModel = GitHubViewModel()

    // MARK: ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
    }

    // MARK: Private

    private func configureTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.updateList = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func configureSearchBar() {
        searchBar.delegate = viewModel
    }
}
