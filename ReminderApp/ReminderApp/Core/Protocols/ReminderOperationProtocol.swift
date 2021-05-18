//
//  ReminderOperationProtocol.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 17.05.2021.
//

import UIKit
protocol ReminderOperationProtocol {
    func switchFlagStatus(indexPath: IndexPath, allReminders: inout [Reminder], delegate: ReminderProtocol?)
    func deleteReminder(indexPath: IndexPath, allReminders: inout [Reminder], delegate: ReminderProtocol?)
    func priorityExclamationString(priority: Priority) -> String
}

extension ReminderOperationProtocol {
    func switchFlagStatus(indexPath: IndexPath, allReminders: inout [Reminder], delegate: ReminderProtocol?) {
        delegate?.switchFlagStatus(reminder: allReminders[indexPath.row])
        for reminderItem in allReminders {
            if reminderItem == allReminders[indexPath.row] {
                if let index = allReminders.firstIndex(of: allReminders[indexPath.row]) {
                    let isFlag = allReminders[index].isFlag
                    allReminders[index].isFlag = !isFlag
                }
            }
        }
    }

    func deleteReminder(indexPath: IndexPath, allReminders: inout [Reminder], delegate: ReminderProtocol?) {
        delegate?.deleteReminder(reminder: allReminders[indexPath.row])
        for reminderItem in allReminders {
            if reminderItem == allReminders[indexPath.row] {
                allReminders = allReminders.filter { $0 != allReminders[indexPath.row] }
                return
            }
        }
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
