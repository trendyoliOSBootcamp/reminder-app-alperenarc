//
//  ViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

private typealias ListInfo = (reminderList: [ReminderList], color: UIColor, name: String)

private extension MainVC {
    enum Constant {
        enum Cell {
            static let myListTableViewCellID = "myListTableViewCell"
            static let myListTableViewCellName = "MyListTableViewCell"
        }
        enum Segue {
            static let reminderListSegueID = "reminderListSegueID"
            static let newReminderSegue = "newReminderSegue"
            static let addListSegueID = "addListSegueID"
        }
        enum ViewController {
            static let mainVCID = "mainVCID"
            static let storyBoardName = "Main"
            static let searchVCID = "SearchResultVCID"
        }
        static let cornerRadius = CGFloat(10)
        static let allListName = "All"
        static let flaggedListName = "Flagged"
        static let flagIcon = "flag.circle.fill"
        static let reminderUserDefaultKey = "ReminderList"
    }
}

final class MainVC: UIViewController, UISearchControllerDelegate {

    @IBOutlet private weak var allSection: UIView!
    @IBOutlet private weak var flaggedSection: UIView!
    @IBOutlet private weak var myListTableView: UITableView!
    @IBOutlet private weak var allCountLabel: UILabel!
    @IBOutlet private weak var flaggedCountLabel: UILabel!

    lazy var storyboardInstance = UIStoryboard(name: Constant.ViewController.storyBoardName, bundle: .main)
    lazy var searchResultViewController = storyboardInstance.instantiateViewController(identifier: Constant.ViewController.searchVCID) as! SearchResultVC
    lazy var searchController = UISearchController(searchResultsController: searchResultViewController)

    var filteredReminderLists: [ReminderList] = []
    var reminderLists: [ReminderList] = [] {
        didSet {
            if !reminderLists.isEmpty {
                saveReminderList(reminderList: self.reminderLists)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reminderLists = fetchAllReminderList()
        setUISettings()
        addRecognizerForSection()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case Constant.Segue.newReminderSegue:
            let newReminderVC = segue.destination as? NewReminderVC
            newReminderVC?.reminderLists = reminderLists
            newReminderVC?.delegate = self
        case Constant.Segue.reminderListSegueID:
            let reminderListVC = segue.destination as? ReminderListVC
            let list = sender as? ListInfo
            reminderListVC?.delegate = self
            reminderListVC?.title = list?.name
            reminderListVC?.reminderList = list?.reminderList ?? []
            reminderListVC?.listColor = list?.color
            reminderListVC?.listName = list?.name
        case Constant.Segue.addListSegueID:
            let addListVC = segue.destination as? AddListVC
            addListVC?.reminderLists = reminderLists
            addListVC?.delegate = self
        default:
            break
        }
    }

    private func fetchAllReminderList() -> [ReminderList] {
        let defaultList = ReminderList(name: "Reminder", icon: "line.horizontal.3.circle.fill", iconColor: .systemBlue, reminders: [])
        if let objects = UserDefaults.standard.value(forKey: Constant.reminderUserDefaultKey) as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [ReminderList] {
                return objectsDecoded
            } else {
                return [defaultList]
            }
        } else {
            return [defaultList]
        }
    }

    private func saveReminderList(reminderList: [ReminderList]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(reminderList) {
            UserDefaults.standard.set(encoded, forKey: Constant.reminderUserDefaultKey)
        }
    }

    private func setUISettings() {
        allSection.layer.cornerRadius = Constant.cornerRadius
        flaggedSection.layer.cornerRadius = Constant.cornerRadius
        myListTableView.layer.cornerRadius = Constant.cornerRadius
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"

        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func addRecognizerForSection() {
        let allSectionClick = UITapGestureRecognizer(target: self, action: #selector(allSectionAction))
        allSection.addGestureRecognizer(allSectionClick)

        let flaggedSectionClick = UITapGestureRecognizer(target: self, action: #selector(flaggedSectionAction))
        flaggedSection.addGestureRecognizer(flaggedSectionClick)
    }

    @objc private func allSectionAction(sender: UITapGestureRecognizer) {
        let allList = filterAllList().list
        let listInfo: ListInfo = (reminderList: allList, color: UIColor(ciColor: .gray), name: Constant.allListName)
        performSegue(withIdentifier: Constant.Segue.reminderListSegueID, sender: listInfo)
    }

    @objc private func flaggedSectionAction(sender: UITapGestureRecognizer) {
        let flaggedList = filterFlaggedList().list
        let listInfo: ListInfo = (reminderList: flaggedList, color: .orange, name: Constant.flaggedListName)
        performSegue(withIdentifier: Constant.Segue.reminderListSegueID, sender: listInfo)
    }

    // Calculate All and Flagged list. Show count on sections
    private func filterFlaggedList() -> (list: [ReminderList], count: Int) {
        var count = 0
        var flaggedList = ReminderList(name: Constant.flaggedListName, icon: Constant.flagIcon, iconColor: .orange, reminders: [])

        let flaggeds = reminderLists.flatMap {
            $0.reminders.filter { $0.isFlag == true }
        }

        for reminder in flaggeds {
            flaggedList.reminders.append(reminder)
        }

        for reminderlist in [flaggedList] {
            for _ in reminderlist.reminders {
                count += 1
            }
        }
        return (list: [flaggedList], count: count)
    }

    private func filterAllList() -> (list: [ReminderList], count: Int) {
        var count = 0

        for reminderlist in reminderLists {
            for _ in reminderlist.reminders {
                count += 1
            }
        }
        return (list: reminderLists, count: count)
    }
}

// MARK: - UITableViewDataSource
extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewIsEmpty(tableView: myListTableView, list: reminderLists, message: "No Reminder List !")
        return reminderLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = myListTableView.dequeueReusableCell(withIdentifier: Constant.Cell.myListTableViewCellID, for: indexPath) as? MyListTableViewCell else { return .init() }
        let reminderList = reminderLists[indexPath.item]
        cell.configure(icon: reminderList.icon, name: reminderList.name, count: reminderList.reminders.count, color: reminderList.iconColor)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminderList = reminderLists[indexPath.row]
        let listInfo: ListInfo = (reminderList: [reminderList], color: reminderList.iconColor, name: reminderList.name)
        performSegue(withIdentifier: Constant.Segue.reminderListSegueID, sender: listInfo)
    }
}

// MARK: - UISearchResultsUpdating
extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let searchResultVC = searchController.searchResultsController as? SearchResultVC else { return }

        searchResultVC.searchText = searchText
        searchResultVC.reminderList = search(searchText: searchText)
        searchResultVC.searchTableView.reloadData()
        searchResultVC.delegate = self
    }
}

// MARK: - UISearchBarDelegate, ReminderProtocol, IsTableViewEmptyProtocol
extension MainVC: UISearchBarDelegate, ReminderDelegate, IsTableViewEmptyProtocol {

    func createNewReminder(reminder: Reminder) {
        let newReminderLists = reminderLists.map { reminderList -> ReminderList in
            if (reminderList.name == reminder.listName) {

                var mutableReminderList = reminderList
                mutableReminderList.reminders.append(reminder)

                return mutableReminderList
            } else {
                return reminderList
            }
        }
        reminderLists = newReminderLists
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func addList(reminderList: ReminderList) {
        reminderLists.append(reminderList)
        myListTableView.reloadData()
    }

    func deleteReminder(reminder: Reminder) {
        for reminderListIndex in 0..<reminderLists.count {
            let reminderList = reminderLists[reminderListIndex].reminders
            for reminderIndex in 0..<reminderList.count {
                if reminderList[reminderIndex] == reminder {
                    reminderLists[reminderListIndex].reminders.remove(at: reminderIndex)
                }
            }
        }
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func switchFlagStatus(reminder: Reminder) {
        for reminderListIndex in 0..<reminderLists.count {
            let reminderList = reminderLists[reminderListIndex].reminders
            for reminderIndex in 0..<reminderList.count {
                if reminderList[reminderIndex] == reminder {
                    let isFlag = reminderLists[reminderListIndex].reminders[reminderIndex].isFlag
                    reminderLists[reminderListIndex].reminders[reminderIndex].isFlag = !isFlag
                }
            }
        }
        flaggedCountLabel.text = "\(filterFlaggedList().count)"
        myListTableView.reloadData()
    }

    func search(searchText: String) -> [ReminderList] {
        filteredReminderLists = reminderLists.filter {
            let reminderListArray = $0.reminders
            for reminderList in reminderListArray {
                if reminderList.notes.lowercased().contains(searchText.lowercased()) {
                    return true
                }
            }
            return false
        }
        return filteredReminderLists
    }
}
