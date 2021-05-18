//
//  ReminderListVCExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit

extension ReminderListVC: UITableViewDataSource, UITableViewDelegate, IsTableViewEmptyProtocol, ReminderOperationProtocol {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewIsEmpty(tableView: reminderListTableView, list: allReminders, message: "No Reminders !")
        return allReminders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderListTableView.dequeueReusableCell(withIdentifier: Constant.reminderCellID) as! ReminderCell

        cell.exclamationLbl.text = self.priorityExclamationString(priority: allReminders[indexPath.row].priority)
        cell.titleLabel.text = allReminders[indexPath.row].notes
        cell.flagIcon.isHidden = !allReminders[indexPath.row].isFlag

        if selectedReminders.contains(allReminders[indexPath.row]) {
            cell.selectIcon.image = UIImage(systemName: "circle.fill")
        } else {
            cell.selectIcon.image = UIImage(systemName: "circle")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if selectedReminders.contains(allReminders[indexPath.row]) {
            if let reminder = selectedReminders.firstIndex(of: allReminders[indexPath.row]) {
                selectedReminders.remove(at: reminder) // array is now ["world", "hello"]
            }
        } else {
            selectedReminders.append(allReminders[indexPath.row])
        }

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Details
        let detail = UIContextualAction(style: .normal, title: "Details") { (action, view, completionHandler) in
            completionHandler(true)
        }
        // Flag
        let flag = UIContextualAction(style: .normal, title: "Flag") { (action, view, completionHandler) in
            self.switchFlagStatus(indexPath: indexPath, allReminders: &self.allReminders, delegate: self.delegate)
            self.reminderListTableView.reloadData()
            completionHandler(true)
        }
        // Delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.deleteReminder(indexPath: indexPath, allReminders: &self.allReminders, delegate: self.delegate)
            self.reminderListTableView.reloadData()
            completionHandler(true)
        }

        detail.backgroundColor = .gray
        delete.backgroundColor = .red
        flag.backgroundColor = .orange

        let swipe = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        return swipe
    }
}
