//
//  ReminderListVC.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 14.05.2021.
//

import UIKit

private extension ReminderListVC {
    enum Constant {
        enum Cell {
            static let reminderCellID = "reminderCellID"
            static let iconFill = "circle.fill"
            static let iconEmpty = "circle"
            static let noRemindersMessage = "No Reminders !"
        }
        static let newReminderFromReminderListSegue = "newReminderFromList"
        static let detailSegue = "DetailFromListSegue"
    }
}

final class ReminderListVC: UIViewController {

    var reminderList: [ReminderList] = []
    var listName: String?
    var listColor: UIColor?
    var allReminders: [Reminder] = []
    var selectedReminders: [Reminder] = []

    @IBOutlet private weak var reminderListTableView: UITableView!
    @IBOutlet private weak var newReminderButton: UIButton!

    var delegate: ReminderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        sumAllReminders()
    }

    @IBAction func checkReminders(_ sender: Any) {
        for reminder in selectedReminders {
            self.deleteReminder(reminder: reminder)
        }
    }

    func setUISettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: listColor ?? UIColor(ciColor: .black)]
        newReminderButton.tintColor = listColor ?? UIColor(ciColor: .black)
        newReminderButton.setTitleColor(listColor ?? UIColor(ciColor: .black), for: .normal)
    }

    func sumAllReminders() {
        allReminders = []
        for reminderlist in reminderList {
            for reminder in reminderlist.reminders {
                allReminders.append(reminder)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ReminderListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedReminders.contains(allReminders[indexPath.row]) {
            if let reminder = selectedReminders.firstIndex(of: allReminders[indexPath.row]) {
                selectedReminders.remove(at: reminder)
            }
        } else {
            selectedReminders.append(allReminders[indexPath.row])
        }

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Details
        let detail = UIContextualAction(style: .normal, title: "Details") { (action, view, completionHandler) in
            self.performSegue(withIdentifier: Constant.detailSegue, sender: self.allReminders[indexPath.row])
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

// MARK: - UITableViewDataSource, ReminderOperationProtocol, IsTableViewEmptyProtocol
extension ReminderListVC: UITableViewDataSource, ReminderOperationDelegate, IsTableViewEmptyProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewIsEmpty(tableView: reminderListTableView, list: allReminders, message: Constant.Cell.noRemindersMessage)
        return allReminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderListTableView.dequeueReusableCell(withIdentifier: Constant.Cell.reminderCellID) as! ReminderCell

        cell.exclamationLbl.text = self.priorityExclamationString(priority: allReminders[indexPath.row].priority)
        cell.titleLabel.text = allReminders[indexPath.row].notes
        cell.flagIcon.isHidden = !allReminders[indexPath.row].isFlag

        if selectedReminders.contains(allReminders[indexPath.row]) {
            cell.selectIcon.image = UIImage(systemName: Constant.Cell.iconFill)
        } else {
            cell.selectIcon.image = UIImage(systemName: Constant.Cell.iconEmpty)
        }
        return cell
    }
}

// MARK: - ReminderProtocol
extension ReminderListVC: ReminderDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constant.newReminderFromReminderListSegue:
            let newReminderVC = segue.destination as? NewReminderVC
            newReminderVC?.reminderLists = reminderList
            newReminderVC?.delegate = self
        case Constant.detailSegue:
            let newReminderVC = segue.destination as? NewReminderVC
            newReminderVC?.currentReminder = sender as? Reminder
            newReminderVC?.reminderLists = reminderList
        default:
            break
        }
    }

    func createNewReminder(reminder: Reminder) {
        let newReminderLists = reminderList.map { reminders -> ReminderList in
            if (reminders.name == reminder.listName) {

                var mutableReminderList = reminders
                mutableReminderList.reminders.append(reminder)

                return mutableReminderList
            } else {
                return reminders
            }
        }
        reminderList = newReminderLists
        sumAllReminders()
        reminderListTableView.reloadData()

        self.delegate?.createNewReminder(reminder: reminder)
    }

    func deleteReminder(reminder: Reminder) {
        for reminderListIndex in 0..<reminderList.count {
            let remindersList = reminderList[reminderListIndex].reminders
            for reminderIndex in 0..<remindersList.count {
                if remindersList[reminderIndex] == reminder {
                    reminderList[reminderListIndex].reminders.remove(at: reminderIndex)
                }
            }
        }

        sumAllReminders()
        reminderListTableView.reloadData()
        self.delegate?.deleteReminder(reminder: reminder)
    }

    func switchFlagStatus(reminder: Reminder) {
        // Not Implemented
    }

    func addList(reminderList: ReminderList) {
        // Not Implemented
    }
}
