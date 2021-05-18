//
//  Reminder.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import Foundation

struct Reminder: Equatable {
    var title: String
    var notes: String
    var listName: String
    var isFlag: Bool
    var priority: Priority

    public static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.title == rhs.title &&
            lhs.notes == rhs.notes &&
            lhs.listName == rhs.listName &&
            lhs.isFlag == rhs.isFlag &&
            lhs.priority == rhs.priority
    }
}

enum Priority: String, CaseIterable {
    case None = "None"
    case Normal = "Normal"
    case Low = "Low"
    case Medium = "Medium"
    case High = "High"
}
