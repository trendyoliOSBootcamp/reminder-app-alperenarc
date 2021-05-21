//
//  ReminderListDelegate.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 14.05.2021.
//

import UIKit

final class ReminderListDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var selectedReminderList: ReminderList
    let reminderList: [ReminderList]
    
    init(reminderLists: [ReminderList]) {
        selectedReminderList = reminderLists[0]
        reminderList = reminderLists
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderList[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedReminderList = reminderList[row]
    }
}
