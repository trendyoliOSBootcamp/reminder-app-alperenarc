//
//  NewReminderVC.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

fileprivate extension NewReminderVC {
    enum Constant {
        static let cornerRadius = CGFloat(10)
        static let blankAlertTitle = "Error !"
        static let blankAlertMessage = "Please fill in the blanks."
        static let alertAction = "Ok"
        static let titlePlaceHolder = "Title"
        static let notesPlaceHolder = "Notes"

    }
    enum PickerType {
        case ReminderList
        case Priority
    }
}

final class NewReminderVC: UIViewController, ShowAlert {

    var reminderLists: [ReminderList]?

    @IBOutlet weak var titleTxtField: UITextView!
    @IBOutlet weak var notesTxtField: UITextView!
    @IBOutlet weak var listSection: UIView!
    @IBOutlet weak var flagSection: UIView!
    @IBOutlet weak var flagSwitch: UISwitch!
    @IBOutlet weak var prioritySection: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!

    var priorityPicker = UIPickerView()
    var priorityToolBar = UIToolbar()

    var reminderListPicker = UIPickerView()
    var reminderListToolBar = UIToolbar()

    var reminderPriorityDelegate = ReminderPriorityDelegate()
    lazy var reminderListDelegate = ReminderListDelegate(reminderLists: reminderLists ?? [])
    var delegate: NewReminderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        addRecognizerForSection()
    }

    func setUISettings() {
        titleTxtField.layer.cornerRadius = Constant.cornerRadius
        titleTxtField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        notesTxtField.layer.cornerRadius = Constant.cornerRadius
        notesTxtField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        flagSection.layer.cornerRadius = Constant.cornerRadius
        listSection.layer.cornerRadius = Constant.cornerRadius
        prioritySection.layer.cornerRadius = Constant.cornerRadius

        listNameLabel.text = reminderLists?[0].name
        titleTxtField.centerVertically()

        titleTxtField.delegate = self
        notesTxtField.delegate = self
    }

    @IBAction func sendData(_ sender: Any) {

        guard let title = titleTxtField.text, !title.isEmpty, let notes = notesTxtField.text, !notes.isEmpty else {
            
            showError(alertTitle: Constant.blankAlertTitle, alertActionTitle: Constant.alertAction, alertMessage: Constant.blankAlertMessage, ownerVC: self)
            return
        }

        let reminder = Reminder(title: title, notes: notes, listName: reminderListDelegate.selectedReminderList.name, isFlag: flagSwitch.isOn, priority: reminderPriorityDelegate.selectedPriority)

        self.delegate?.createNewReminder(reminder: reminder)
        dismiss(animated: true, completion: nil)
    }

    func addRecognizerForSection() {
        let listSectionClick = UITapGestureRecognizer(target: self, action: #selector(createListPicker))
        listSection.addGestureRecognizer(listSectionClick)

        let prioritySectionClick = UITapGestureRecognizer(target: self, action: #selector(createPriorityPicker))
        prioritySection.addGestureRecognizer(prioritySectionClick)
    }

    @objc func createListPicker() {
        reminderListPicker = UIPickerView()
        reminderListPicker.delegate = reminderListDelegate
        reminderListPicker.dataSource = reminderListDelegate
        reminderListPicker.autoresizingMask = .flexibleWidth
        reminderListPicker.contentMode = .center
        reminderListPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(reminderListPicker)

        reminderListToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        reminderListToolBar.barStyle = .default

        reminderListToolBar.items = [UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectReminderList))]
        self.view.addSubview(reminderListToolBar)

    }

    @objc func createPriorityPicker() {
        priorityPicker = UIPickerView()
        priorityPicker.delegate = reminderPriorityDelegate
        priorityPicker.dataSource = reminderPriorityDelegate
        priorityPicker.autoresizingMask = .flexibleWidth
        priorityPicker.contentMode = .center
        priorityPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(priorityPicker)

        priorityToolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        priorityToolBar.barStyle = .default

        priorityToolBar.items = [UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectPriority))]
        self.view.addSubview(priorityToolBar)

    }

    private func onDoneButtonTapped(pickerType: PickerType) {

        switch pickerType {
        case .Priority:
            priorityToolBar.removeFromSuperview()
            priorityPicker.removeFromSuperview()
        case .ReminderList:
            reminderListToolBar.removeFromSuperview()
            reminderListPicker.removeFromSuperview()
        }
    }

    @objc func selectPriority() {
        onDoneButtonTapped(pickerType: .Priority)
        priorityLabel.text = reminderPriorityDelegate.selectedPriority.rawValue
        self.view.endEditing(true)
    }

    @objc func selectReminderList() {
        onDoneButtonTapped(pickerType: .ReminderList)
        listNameLabel.text = reminderListDelegate.selectedReminderList.name
        self.view.endEditing(true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
