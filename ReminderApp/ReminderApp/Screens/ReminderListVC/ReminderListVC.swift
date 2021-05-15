//
//  ReminderListVC.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 14.05.2021.
//

import UIKit

class ReminderListVC: UIViewController {

    var reminderList: [ReminderList] = []
    var listName: String?
    var listColor: UIColor?
    var allReminders: [Reminder] = []

    @IBOutlet weak var reminderListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setUISettings()
        sumAllReminders()
    }

    func setDelegates() {
        reminderListTableView.delegate = self
        reminderListTableView.dataSource = self
    }
    func setUISettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: listColor ?? UIColor(ciColor: .black)]
    }

    func sumAllReminders() {
        for reminderlist in reminderList {
            for reminder in reminderlist.reminders {
                allReminders.append(reminder)
            }
        }
    }
}
