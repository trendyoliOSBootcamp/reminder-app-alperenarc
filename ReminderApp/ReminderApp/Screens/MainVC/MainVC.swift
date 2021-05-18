//
//  ViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 13.05.2021.
//

import UIKit

typealias ListInfo = (reminderList: [ReminderList], color: UIColor, name: String)

extension MainVC {
    enum Constant {
        static let cornerRadius = CGFloat(10)
        static let newReminderSegue = "newReminderSegue"
        static let mainVCID = "mainVCID"
        static let myListTableViewCellID = "myListTableViewCell"
        static let myListTableViewCellName = "MyListTableViewCell"
        static let reminderListSegueID = "reminderListSegueID"
        static let addListSegueID = "addListSegueID"
        static let allListName = "All"
        static let flaggedListName = "Flagged"
        static let flagIcon = "flag.circle.fill"
        static let storyBoardName = "Main"
        static let searchVCID = "SearchResultVCID"
    }
}

final class MainVC: UIViewController, UISearchControllerDelegate {

    @IBOutlet weak var allSection: UIView!
    @IBOutlet weak var flaggedSection: UIView!
    @IBOutlet weak var myListTableView: UITableView!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var flaggedCountLabel: UILabel!

    var reminderLists: [ReminderList] = [
        ReminderList(name: "Reminder", icon: "flag.circle.fill", iconColor: .orange, reminders: [Reminder(title: "Deneme", notes: "Not Bölümü", listName: "Reminder", isFlag: true, priority: .High),
            Reminder(title: "Other Reminder", notes: "Not alacağım", listName: "Reminder", isFlag: true, priority: .Low)]),
        ReminderList(name: "Other List", icon: "circle", iconColor: .red, reminders: [Reminder(title: "Other ", notes: "Not al", listName: "Other List", isFlag: true, priority: .High)])

    ]

    lazy var storyboardInstance = UIStoryboard(name: Constant.storyBoardName, bundle: .main)
    lazy var searchResultViewController = storyboardInstance.instantiateViewController(identifier: Constant.searchVCID) as! SearchResultVC
    lazy var searchController = UISearchController(searchResultsController: searchResultViewController)

    var filteredReminderLists: [ReminderList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        addRecognizerForSection()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func setUISettings() {
        allSection.layer.cornerRadius = Constant.cornerRadius
        flaggedSection.layer.cornerRadius = Constant.cornerRadius
        myListTableView.layer.cornerRadius = Constant.cornerRadius
        allCountLabel.text = "\(filterAllList().count)"
        flaggedCountLabel.text = "\(filterFlaggedList().count)"

        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func addRecognizerForSection() {
        let allSectionClick = UITapGestureRecognizer(target: self, action: #selector(allSectionAction))
        allSection.addGestureRecognizer(allSectionClick)

        let flaggedSectionClick = UITapGestureRecognizer(target: self, action: #selector(flaggedSectionAction))
        flaggedSection.addGestureRecognizer(flaggedSectionClick)
    }

    @objc func allSectionAction(sender: UITapGestureRecognizer) {
        let allList = filterAllList().list
        let listInfo: ListInfo = (reminderList: allList, color: UIColor(ciColor: .gray), name: Constant.allListName)
        performSegue(withIdentifier: Constant.reminderListSegueID, sender: listInfo)
    }

    @objc func flaggedSectionAction(sender: UITapGestureRecognizer) {
        let flaggedList = filterFlaggedList().list
        let listInfo: ListInfo = (reminderList: flaggedList, color: .orange, name: Constant.flaggedListName)
        performSegue(withIdentifier: Constant.reminderListSegueID, sender: listInfo)
    }

    // Calculate All and Flagged list. Show count on sections
    func filterFlaggedList() -> (list: [ReminderList], count: Int) {
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

    func filterAllList() -> (list: [ReminderList], count: Int) {
        var count = 0

        for reminderlist in reminderLists {
            for _ in reminderlist.reminders {
                count += 1
            }
        }
        return (list: reminderLists, count: count)
    }

    @IBAction func newReminderAction(_ sender: Any) {
    }
    @IBAction func addListAction(_ sender: Any) {
    }
}
