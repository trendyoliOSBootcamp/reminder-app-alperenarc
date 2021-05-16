//
//  UITableViewExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import Foundation
import UIKit

extension MainVC: UITableViewDataSource, UITableViewDelegate, NewReminderProtocol, AddListProtocol {

    func createNewReminder(reminder: Reminder) {
        let newReminderLists = reminderLists.map { reminderList -> ReminderList in
            if (reminderList.name == reminder.listName) {

                var mutableReminderList = reminderList
                mutableReminderList.reminders.append(reminder)

                return mutableReminderList
            } else {
                return reminderList
            }
        }
        reminderLists = newReminderLists
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func addList(reminderList: ReminderList) {
        reminderLists.append(reminderList)
        myListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = myListTableView.dequeueReusableCell(withIdentifier: Constant.myListTableViewCellID, for: indexPath) as? MyListTableViewCell else { return .init() }
        let reminderList = reminderLists[indexPath.item]
        cell.configure(icon: reminderList.icon, name: reminderList.name, count: reminderList.reminders.count, color: reminderList.iconColor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case Constant.newReminderSegue:
            let newReminderVC = segue.destination as? NewReminderVC
            newReminderVC?.reminderLists = reminderLists
            newReminderVC?.delegate = self

        case Constant.reminderListSegueID:
            let reminderListVC = segue.destination as? ReminderListVC
            let list = sender as? ListInfo
            reminderListVC?.title = list?.name
            reminderListVC?.reminderList = list?.reminderList ?? []
            reminderListVC?.listColor = list?.color
            reminderListVC?.listName = list?.name

        case Constant.addListSegueID:
            let addListVC = segue.destination as? AddListVC
            addListVC?.reminderLists = reminderLists
            addListVC?.delegate = self
        default:
            break
        }
    }
}
