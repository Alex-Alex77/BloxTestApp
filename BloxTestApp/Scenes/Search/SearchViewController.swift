//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var backgroundViewLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: ViewModel

    // Should be injected, but initialized here for simplicity
    private let viewModel = SearchViewModel()

    // MARK: ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.isHidden = false
        backgroundViewLabel.text = "Enter some text for loading repositories"
        configureTableView()
        configureSearchBar()
        bindViewModel()
    }

    // MARK: Private

    private func configureTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        // Used for not showing redundant separator lines
        tableView.tableFooterView = UIView()
        tableView.backgroundView = backgroundView
    }

    private func configureSearchBar() {
        searchBar.delegate = viewModel
    }

    private func bindViewModel() {
        viewModel.loadedAction = { [weak self] success in
            guard let strongSelf = self else { return }

            let backgroundLabelText: String
            if success {
                backgroundLabelText = strongSelf.viewModel.repositories.isEmpty ? "No results" : ""
            } else {
                backgroundLabelText = "Sorry, there was an error during loading repositories. Try again!"
            }
            strongSelf.backgroundViewLabel.text = backgroundLabelText
            strongSelf.backgroundView.isHidden = success
            strongSelf.tableView.reloadData()
        }

        viewModel.isLoading = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                 self?.loadingIndicator.stopAnimating()
            }
        }
    }
}
