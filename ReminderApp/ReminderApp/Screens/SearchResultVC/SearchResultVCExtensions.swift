//
//  SearchResultVCExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 17.05.2021.
//

import UIKit

extension SearchResultVC: UITableViewDelegate, UITableViewDataSource, ReminderOperationProtocol {

    func numberOfSections(in tableView: UITableView) -> Int {
        reminderList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderList[section].reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: Constant.searchCellID, for: indexPath) as? SearchTableViewCell else { return .init() }

        cell.noteLabel.text = reminderList[indexPath.section].reminders[indexPath.row].notes
        cell.flagImage.isHidden = !reminderList[indexPath.section].reminders[indexPath.row].isFlag

        let priority = reminderList[indexPath.section].reminders[indexPath.row].priority
        cell.exclamationLabel.text = priorityExclamationString(priority: priority)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = .white
        let title = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 50))
        title.text = reminderList[section].name
        title.textColor = reminderList[section].iconColor
        title.font = UIFont.boldSystemFont(ofSize: 25.0)
        view.addSubview(title)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Details
        let detail = UIContextualAction(style: .normal, title: "Details") { (action, view, completionHandler) in
            completionHandler(true)
        }
        // Flag
        let flag = UIContextualAction(style: .normal, title: "Flag") { (action, view, completionHandler) in
            self.switchFlagStatus(indexPath: indexPath, allReminders: &self.reminderList[indexPath.section].reminders, delegate: self.delegate)
            self.searchTableView.reloadData()
            completionHandler(true)
        }
        // Delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.deleteReminder(indexPath: indexPath, allReminders: &self.reminderList[indexPath.section].reminders, delegate: self.delegate)
            self.searchTableView.reloadData()
            completionHandler(true)
        }

        detail.backgroundColor = .gray
        delete.backgroundColor = .red
        flag.backgroundColor = .orange

        let swipe = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        return swipe
    }
}
