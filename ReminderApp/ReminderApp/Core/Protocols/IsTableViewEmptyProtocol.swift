//
//  IsTableViewEmptyProtocol.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 16.05.2021.
//

import UIKit

protocol IsTableViewEmptyProtocol {
    func tableViewIsEmpty<T>(tableView: UITableView, list: [T],message: String)
}

extension IsTableViewEmptyProtocol {
    func tableViewIsEmpty<T>(tableView: UITableView, list: [T], message: String) {
        if list.isEmpty {
            tableView.setEmptyMessage(message: message)
        } else {
            tableView.restore()
        }
    }
}
