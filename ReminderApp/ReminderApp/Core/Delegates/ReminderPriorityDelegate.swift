//
//  ReminderPriorityDelegate.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

final class ReminderPriorityDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var selectedPriority: Priority = .None

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Priority.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Priority.allCases[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = Priority.allCases[row]
    }
}
