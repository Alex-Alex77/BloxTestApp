//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class RepositoriesViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var nextPageLoadingView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var state = State.loading {
        didSet {
            updateViewsState()
            tableView.reloadData()
        }
    }

    // MARK: ViewModel

    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = RepositoriesViewModel()

    // MARK: ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search reposotories"
        viewModel.delegate = self
        hideKeyboardOnTap()
        prepareTableView()
        prepareSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: Keyboard hiding

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }

    // MARK: Prepare views

    private func prepareTableView() {
        tableView.dataSource = self
    }

    private func prepareSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        navigationItem.searchController = searchController
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: Update views

    private func updateViewsState() {
        if case .loading = state {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        let stateView: UIView
        switch state {
        case .error(let error):
            errorLabel.text = error.localizedDescription
            stateView = errorView
        case .paging:
            stateView = nextPageLoadingView
        case .empty:
            stateView = emptyView
        case .loading, .populated:
            stateView = UIView()
        }
        tableView.tableFooterView = stateView
    }

    // MARK: Load items

    @objc private func loadItems() {
        state = .loading
        loadPage(1)
    }

    private func loadPage(_ page: Int) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        viewModel.load(query: query, page: page)
    }
}

// MARK: UISearchBarDelegate

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(loadItems),
                                               object: nil)

        perform(#selector(loadItems), with: nil, afterDelay: 0.5)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: UITableViewDataSource

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.currentItems.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case .paging(_, let nextPage) = state,
            indexPath.row == state.currentItems.count - 5 {
            loadPage(nextPage)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = state.currentItems[indexPath.row]
        let cell: RepositoryCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = RepositoryCellViewModel(repository: item)
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: SearchViewModelDelegate

extension RepositoriesViewController: SearchViewModelDelegate {
    func update(response: ItemsResult) {
        if let error = response.error {
            state = .error(error)
            return
        }

        guard let newItems = response.items, !newItems.isEmpty else {
            state = .empty
            return
        }

        var allItems = state.currentItems
        allItems.append(contentsOf: newItems)

        if response.hasMorePages {
            state = .paging(allItems, next: response.nextPage)
        } else {
            state = .populated(allItems)
        }
    }
}
