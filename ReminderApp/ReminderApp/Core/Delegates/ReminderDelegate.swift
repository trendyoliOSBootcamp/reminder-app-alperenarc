//
//  NewReminderProtocol.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import Foundation

protocol ReminderDelegate {
    func createNewReminder(reminder: Reminder)
    func deleteReminder(reminder: Reminder)
    func switchFlagStatus(reminder: Reminder)
    func addList(reminderList: ReminderList)
}
