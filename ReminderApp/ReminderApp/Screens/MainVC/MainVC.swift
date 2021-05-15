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
        static let allListName = "All"
        static let flaggedListName = "Flagged"
        static let flagIcon = "flag.circle.fill"
    }
}

final class MainVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var allSection: UIView!
    @IBOutlet weak var flaggedSection: UIView!
    @IBOutlet weak var myListTableView: UITableView!

    var reminderLists: [ReminderList] = [
        ReminderList(name: "Reminder", icon: "flag.circle.fill", iconColor: .orange, reminders: []),
        ReminderList(name: "Anımsatıcılar", icon: "line.horizontal.3.circle.fill", iconColor: .red, reminders: []),

        ReminderList(name: "Okul", icon: "line.horizontal.2.circle.fill", iconColor: .blue, reminders: [
            Reminder(title: "Okul stuff", notes: "Uzun ", listName: "Okul", isFlag: true, priority: .High),
            Reminder(title: "Okul", notes: "Uzun bir string Uzun bir string Uzun bir string Uzun bir string Uzun bir string Uzun bir string", listName: "Okul", isFlag: true, priority: .Medium)

            ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        addRecognizerForSection()
//        myListTableView.setEmptyMessage(message: "No Reminder !")
//        myListTableView.register(UINib(nibName: Constant.myListTableViewCellName, bundle: nil), forCellReuseIdentifier: Constant.myListTableViewCellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setUISettings() {
        allSection.layer.cornerRadius = Constant.cornerRadius
        flaggedSection.layer.cornerRadius = Constant.cornerRadius
        myListTableView.layer.cornerRadius = Constant.cornerRadius

    }

    func addRecognizerForSection() {
        let allSectionClick = UITapGestureRecognizer(target: self, action: #selector(allSectionAction))
        allSection.addGestureRecognizer(allSectionClick)

        let flaggedSectionClick = UITapGestureRecognizer(target: self, action: #selector(flaggedSectionAction))
        flaggedSection.addGestureRecognizer(flaggedSectionClick)
    }

    @objc func allSectionAction(sender: UITapGestureRecognizer) {
        let listInfo: ListInfo = (reminderList: reminderLists, color: UIColor(ciColor: .gray), name: Constant.allListName)
        performSegue(withIdentifier: Constant.reminderListSegueID, sender: listInfo)
    }

    @objc func flaggedSectionAction(sender: UITapGestureRecognizer) {
        var flaggedList = ReminderList(name: Constant.flaggedListName, icon: Constant.flagIcon, iconColor: .orange, reminders: [])

        let flaggeds = reminderLists.flatMap {
            $0.reminders.filter { $0.isFlag == true }
        }

        for reminder in flaggeds {
            flaggedList.reminders.append(reminder)
        }

        let listInfo: ListInfo = (reminderList: [flaggedList], color: .orange, name: Constant.flaggedListName)
        performSegue(withIdentifier: Constant.reminderListSegueID, sender: listInfo)
    }

    @IBAction func newReminderAction(_ sender: Any) {
    }
    @IBAction func addListAction(_ sender: Any) {
    }
}
