//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

final class UserRepositoriesViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: Private

    private func configureTableView() {
        // Used for not showing redundant separator lines
        tableView.tableFooterView = UIView()
    }
}
