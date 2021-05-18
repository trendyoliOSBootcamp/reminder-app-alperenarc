//
//  AddListVCViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit

extension AddListVC {
    enum Constant {
        static let ColorCellID = "ColorCellID"
        static let IconCellID = "IconCellID"
        static let borderWidthActive = CGFloat(2)
        static let borderWidthDeactive = CGFloat(0)
        static let borderCorner = CGFloat(50 / 2)
        static let listNameAlertTitle = "Error"
        static let listNameAlertAction = "Ok"
        static let listNameBlankAlertMessage = "Please enter a list name !"
        static let listNameExistsAlertMessage = "List Name already exits. Please enter a new list name !"
        static let colors: [UIColor] = [.red, .orange, .systemYellow, .systemGreen, .systemBlue, .blue, .purple, .systemPink, .brown, .darkGray, .lightGray, .cyan]
        static let icons: [String] = ["smiley", "line.horizontal.3.circle.fill", "bookmark.fill", "key.fill", "gift.fill", "phone.bubble.left.fill"]
    }
}

final class AddListVC: UIViewController, ShowAlert {

    var delegate: ReminderProtocol?
    var reminderLists: [ReminderList] = []
    var selectedColor: UIColor = Constant.colors[4]
    var selectedIcon: String = Constant.icons[1]

    @IBOutlet weak var mainIconImage: UIImageView!
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }

    func setDelegates() {
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        iconsCollectionView.delegate = self
        iconsCollectionView.dataSource = self
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneAction(_ sender: Any) {
        // If list name is blank, show error
        guard let listname = listName.text, !listname.isEmpty else {
            showError(alertTitle: Constant.listNameAlertTitle, alertActionTitle: Constant.listNameAlertAction, alertMessage: Constant.listNameBlankAlertMessage, ownerVC: self)
            return
        }

        // If list name already exists, show error
        for reminderList in reminderLists {
            if reminderList.name == listname {
                showError(alertTitle: Constant.listNameAlertTitle, alertActionTitle: Constant.listNameAlertAction, alertMessage: Constant.listNameExistsAlertMessage, ownerVC: self)
                listName.text = ""
                return
            }
        }

        // Save list and return with delegate
        let newReminderList = ReminderList(name: listname, icon: selectedIcon, iconColor: selectedColor, reminders: [])
        self.delegate?.addList(reminderList: newReminderList)
        
        dismiss(animated: true, completion: nil)
    }
}
