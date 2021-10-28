//
//  CountryTableViewDataSource.swift
//  Ribbit
//
//  Created by Ahsan Ali on 07/04/2021.
//

import Foundation
import UIKit
class CountryTableViewDataSource<CELL: UITableViewCell, T>: NSObject, UITableViewDataSource {
    private var cellIdentifier: String!
    private var items: [T]!
    var configureCell: (CELL, T) -> Void = { _, _ in }
    init(cellIdentifier: String, items: [T], configureCell: @escaping (CELL, T) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CELL else {
            return UITableViewCell()
        }

        let item = self.items[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
}
