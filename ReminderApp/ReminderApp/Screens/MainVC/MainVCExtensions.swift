//
//  UITableViewExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import Foundation
import UIKit

extension MainVC: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ReminderProtocol, IsTableViewEmptyProtocol, UISearchResultsUpdating {

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

    func deleteReminder(reminder: Reminder) {

        for reminderListIndex in 0..<reminderLists.count {
            let reminderList = reminderLists[reminderListIndex].reminders
            for reminderIndex in 0..<reminderList.count {
                if reminderList[reminderIndex] == reminder {
                    reminderLists[reminderListIndex].reminders.remove(at: reminderIndex)
                }
            }
        }
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func switchFlagStatus(reminder: Reminder) {
        for reminderListIndex in 0..<reminderLists.count {
            let reminderList = reminderLists[reminderListIndex].reminders
            for reminderIndex in 0..<reminderList.count {
                if reminderList[reminderIndex] == reminder {
                    let isFlag = reminderLists[reminderListIndex].reminders[reminderIndex].isFlag
                    reminderLists[reminderListIndex].reminders[reminderIndex].isFlag = !isFlag
                }
            }
        }
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewIsEmpty(tableView: myListTableView, list: reminderLists, message: "No Reminder List !")
        return reminderLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = myListTableView.dequeueReusableCell(withIdentifier: Constant.myListTableViewCellID, for: indexPath) as? MyListTableViewCell else { return .init() }
        let reminderList = reminderLists[indexPath.item]
        cell.configure(icon: reminderList.icon, name: reminderList.name, count: reminderList.reminders.count, color: reminderList.iconColor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let reminderList = reminderLists[indexPath.row]

        let listInfo: ListInfo = (reminderList: [reminderList], color: reminderList.iconColor, name: reminderList.name)
        performSegue(withIdentifier: Constant.reminderListSegueID, sender: listInfo)
    }

    func updateSearchResults(for searchController: UISearchController) {

        guard let searchText = searchController.searchBar.text else { return }

        if let vc = searchController.searchResultsController as? SearchResultVC {
            vc.searchText = searchText
            vc.reminderList = search(searchText: searchText)
            vc.searchTableView.reloadData()
            vc.delegate = self
        }

    }

    func search(searchText: String) -> [ReminderList] {
        filteredReminderLists = reminderLists.filter {
            let reminderListArray = $0.reminders
            for reminderList in reminderListArray {
                if reminderList.notes.contains(searchText) {
                    return true
                }
            }
            return false
        }

        return filteredReminderLists
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
            reminderListVC?.delegate = self
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
