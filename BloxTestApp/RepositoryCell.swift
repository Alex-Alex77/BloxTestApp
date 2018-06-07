//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

struct RepositoryCellViewModel {
    let name: String
    let url: String
}

class RepositoryCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!

    func configure(with viewModel: RepositoryCellViewModel) {
        nameLabel.text = viewModel.name
        urlLabel.text = viewModel.url
    }
}
