//
//  MyListTableViewCell.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

final class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderListIcon: UIImageView!
    @IBOutlet weak var reminderListName: UILabel!
    @IBOutlet weak var reminderListCount: UILabel!

    func configure(icon: String, name: String, count: Int, color: UIColor) {
        reminderListIcon.image  = UIImage(systemName: icon)
        reminderListIcon.tintColor = color
        reminderListName.text = name
        reminderListCount.text = String(count)
    }
}
