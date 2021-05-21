//
//  NewReminderVC.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

private extension NewReminderVC {
    enum Constant {
        enum Alert {
            static let blankAlertTitle = "Error !"
            static let blankAlertMessage = "Please fill in the blanks."
            static let alertAction = "Ok"
            static let titlePlaceHolder = "Title"
            static let notesPlaceHolder = "Notes"
        }
        enum Picker {
            static let height = CGFloat(300)
        }
        enum Toolbar {
            static let minusHeight = CGFloat(300)
            static let height = CGFloat(50)
        }
        static let cornerRadius = CGFloat(10)
    }
    enum PickerType {
        case ReminderList
        case Priority
    }
}

final class NewReminderVC: UIViewController, ShowAlert, UITextFieldDelegate {

    var reminderLists: [ReminderList]?
    var currentReminder: Reminder?

    @IBOutlet private weak var titleTxtField: UITextField!
    @IBOutlet private weak var notesTxtField: UITextField!
    @IBOutlet private weak var listSection: UIView!
    @IBOutlet private weak var flagSection: UIView!
    @IBOutlet private weak var flagSwitch: UISwitch!
    @IBOutlet private weak var prioritySection: UIView!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var listNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    private var priorityPicker = UIPickerView()
    private var priorityToolBar = UIToolbar()
    private var reminderListPicker = UIPickerView()
    private var reminderListToolBar = UIToolbar()

    var reminderPriorityDelegate = ReminderPriorityDelegate()
    lazy var reminderListDelegate = ReminderListDelegate(reminderLists: reminderLists ?? [])
    var delegate: ReminderDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        addRecognizerForSection()
        loadDataForDetail()
    }

    func loadDataForDetail() {
        guard let reminder = currentReminder else { return }
        
        titleTxtField.text = reminder.title
        notesTxtField.text = reminder.notes
        flagSwitch.setOn(reminder.isFlag, animated: true)
        titleLabel.text = "Detail"
        listNameLabel.text = reminder.listName
        priorityLabel.text = reminder.priority.rawValue
        
        addButton.isEnabled = false
        titleTxtField.isEnabled = false
        notesTxtField.isEnabled = false
        flagSwitch.isEnabled = false
        priorityPicker.isUserInteractionEnabled = false
        reminderListPicker.isUserInteractionEnabled = false
    }

    private func setUISettings() {
        titleTxtField.layer.cornerRadius = Constant.cornerRadius
        titleTxtField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        notesTxtField.layer.cornerRadius = Constant.cornerRadius
        notesTxtField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        flagSection.layer.cornerRadius = Constant.cornerRadius
        listSection.layer.cornerRadius = Constant.cornerRadius
        prioritySection.layer.cornerRadius = Constant.cornerRadius
        listNameLabel.text = reminderLists?[0].name
        titleTxtField.setBorder()
        titleTxtField.setPadding()
        notesTxtField.setPadding()
        titleTxtField.delegate = self
        notesTxtField.delegate = self
    }

    @IBAction func sendData(_ sender: Any) {
        guard let title = titleTxtField.text, !title.isEmpty, let notes = notesTxtField.text, !notes.isEmpty else {

            showError(alertTitle: Constant.Alert.blankAlertTitle, alertActionTitle: Constant.Alert.alertAction, alertMessage: Constant.Alert.blankAlertMessage, ownerVC: self)
            return
        }
        let reminder = Reminder(title: title, notes: notes, listName: reminderListDelegate.selectedReminderList.name, isFlag: flagSwitch.isOn, priority: reminderPriorityDelegate.selectedPriority)

        self.delegate?.createNewReminder(reminder: reminder)
        dismiss(animated: true, completion: nil)
    }

    func addRecognizerForSection() {
        // For Detail
        if currentReminder != nil { return }
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
        reminderListPicker.frame = CGRect.init(x: .zero, y: UIScreen.main.bounds.size.height - Constant.Picker.height, width: UIScreen.main.bounds.size.width, height: Constant.Picker.height)
        self.view.addSubview(reminderListPicker)

        reminderListToolBar = UIToolbar.init(frame: CGRect.init(x: .zero, y: UIScreen.main.bounds.size.height - Constant.Toolbar.minusHeight, width: UIScreen.main.bounds.size.width, height: Constant.Toolbar.height))
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
        priorityPicker.frame = CGRect.init(x: .zero, y: UIScreen.main.bounds.size.height - Constant.Picker.height, width: UIScreen.main.bounds.size.width, height: Constant.Picker.height)
        self.view.addSubview(priorityPicker)

        priorityToolBar = UIToolbar.init(frame: CGRect.init(x: .zero, y: UIScreen.main.bounds.size.height - Constant.Toolbar.minusHeight, width: UIScreen.main.bounds.size.width, height: Constant.Toolbar.height))
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
