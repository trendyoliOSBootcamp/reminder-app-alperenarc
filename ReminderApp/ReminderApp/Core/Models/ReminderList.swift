//
//  ReminderList.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

struct ReminderList: Codable {
    var name: String
    var icon: String
    var iconColor: UIColor
    var reminders: [Reminder]

    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case iconColor
        case reminders
    }
    init(name: String, icon: String, iconColor: UIColor, reminders: [Reminder]) {
        self.name = name
        self.icon = icon
        self.iconColor = iconColor
        self.reminders = reminders
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        iconColor = try container.decode(Color.self, forKey: .iconColor).uiColor
        reminders = try container.decode([Reminder].self, forKey: .reminders)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(Color(uiColor: iconColor), forKey: .iconColor)
        try container.encode(reminders, forKey: .reminders)
    }
}

struct Color: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
