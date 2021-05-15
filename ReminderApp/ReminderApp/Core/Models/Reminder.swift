//
//  Reminder.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import Foundation

struct Reminder {
    var title: String
    var notes: String
    var listName: String
    var isFlag: Bool
    var priority: Priority
}

enum Priority: String, CaseIterable {
    case None = "None"
    case Normal = "Normal"
    case Low = "Low"
    case Medium = "Medium"
    case High = "High"
}
