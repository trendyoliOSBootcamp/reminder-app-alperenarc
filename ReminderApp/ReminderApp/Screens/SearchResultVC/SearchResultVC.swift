//
//  SearchResultVCViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 16.05.2021.
//

import UIKit

private extension SearchResultVC {
    enum Constant {
        enum Cell {
            static let height = CGFloat(50)
            static let labelXPostion = CGFloat(15)
            static let labelFontSize = CGFloat(25)
        }
        static let searchCellID = "searchCellID"
        static let detailSegue = "DetailFromSearchSegue"
    }
}

final class SearchResultVC: UIViewController {

    var reminderList: [ReminderList] = []
    var searchText: String?

    //It is used on the MainVC side.
    @IBOutlet weak var searchTableView: UITableView!

    var delegate: ReminderDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.detailSegue {
            let newReminderVC = segue.destination as? NewReminderVC
            newReminderVC?.currentReminder = sender as? Reminder
            newReminderVC?.reminderLists = reminderList
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderList[section].reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: Constant.searchCellID, for: indexPath) as? SearchTableViewCell else { return .init() }

        cell.noteLabel.text = reminderList[indexPath.section].reminders[indexPath.row].notes
        cell.flagImage.isHidden = !reminderList[indexPath.section].reminders[indexPath.row].isFlag

        let priority = reminderList[indexPath.section].reminders[indexPath.row].priority
        cell.exclamationLabel.text = priorityExclamationString(priority: priority)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        reminderList.count
    }
}

// MARK: - UITableViewDelegate and ReminderOperationProtocol
extension SearchResultVC: UITableViewDelegate, ReminderOperationDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: Constant.Cell.height))
        view.backgroundColor = .white
        let title = UILabel(frame: CGRect(x: Constant.Cell.labelXPostion, y: .zero, width: view.frame.width - Constant.Cell.labelXPostion, height: Constant.Cell.height))
        title.text = reminderList[section].name
        title.textColor = reminderList[section].iconColor
        title.font = UIFont.boldSystemFont(ofSize: Constant.Cell.labelFontSize)
        view.addSubview(title)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constant.Cell.height
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Details
        let detail = UIContextualAction(style: .normal, title: "Details") { (action, view, completionHandler) in
            self.performSegue(withIdentifier: Constant.detailSegue, sender: self.reminderList[indexPath.section].reminders[indexPath.row])
            completionHandler(true)
        }
        // Flag
        let flag = UIContextualAction(style: .normal, title: "Flag") { (action, view, completionHandler) in
            self.switchFlagStatus(indexPath: indexPath, allReminders: &self.reminderList[indexPath.section].reminders, delegate: self.delegate)
            self.searchTableView.reloadData()
            completionHandler(true)
        }
        // Delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            self.deleteReminder(indexPath: indexPath, allReminders: &self.reminderList[indexPath.section].reminders, delegate: self.delegate)
            self.searchTableView.reloadData()
            completionHandler(true)
        }
        detail.backgroundColor = .gray
        delete.backgroundColor = .red
        flag.backgroundColor = .orange

        let swipe = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        return swipe
    }
}
