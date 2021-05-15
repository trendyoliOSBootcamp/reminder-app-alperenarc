//
//  ReminderListVCExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit

extension ReminderListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allReminders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderListTableView.dequeueReusableCell(withIdentifier: "reminderCellID") as! ReminderCell

        cell.exclamationLbl.text = priorityExclamationString(priority: allReminders[indexPath.row].priority)
        cell.titleLabel.text = allReminders[indexPath.row].notes
        cell.flagIcon.isHidden = !allReminders[indexPath.row].isFlag
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Details
        let detail = UIContextualAction(style: .normal, title: "Details") { (action, view, completionHandler) in
            completionHandler(true)
        }
        detail.backgroundColor = .gray
        // Flag
        let flag = UIContextualAction(style: .normal, title: "Flag") { (action, view, completionHandler) in
            completionHandler(true)
        }
        flag.backgroundColor = .orange
        // Delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            completionHandler(true)
        }
        delete.backgroundColor = .red

        let swipe = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        return swipe
    }

    func priorityExclamationString(priority: Priority) -> String {
        switch priority {
        case .Low:
            return "!"
        case .Medium:
            return "!!"
        case .High:
            return "!!!"
        default:
            return ""
        }
    }
}
