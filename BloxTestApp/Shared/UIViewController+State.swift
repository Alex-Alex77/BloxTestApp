//
// Created by Alex Alexandrovych on 27/03/2018
// Copyright © 2018 Alex Alexandrovych. All rights reserved.
//

import UIKit

extension UIViewController {
    enum State {
        case loading
        case paging([Repository], next: Int)
        case populated([Repository])
        case empty
        case error(Error)

        var currentItems: [Repository] {
            switch self {
            case .paging(let items, _):
                return items
            case .populated(let items):
                return items
            default:
                return []
            }
        }
    }

    struct ItemsResult {
        let items: [Repository]?
        let error: Error?
        let currentPage: Int
        let pageCount: Int

        var hasMorePages: Bool {
            return currentPage < pageCount
        }

        var nextPage: Int {
            return hasMorePages ? currentPage + 1 : currentPage
        }
    }
}
