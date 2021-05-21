//
//  AddListVCViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit

private extension AddListVC {
    enum Constant {
        enum Cell {
            static let ColorCellID = "ColorCellID"
            static let IconCellID = "IconCellID"
            static let cellSize = CGFloat(50)
        }
        enum IconImage {
            static let borderWidthActive = CGFloat(2)
            static let borderWidthDeactive = CGFloat(0)
            static let borderCorner = CGFloat(50 / 2)
        }
        enum Alert {
            static let listNameAlertTitle = "Error"
            static let listNameAlertAction = "Ok"
            static let listNameBlankAlertMessage = "Please enter a list name !"
            static let listNameExistsAlertMessage = "List Name already exits. Please enter a new list name !"
        }
        static let colors: [UIColor] = [.red, .orange, .systemYellow, .systemGreen, .systemBlue, .blue, .purple, .systemPink, .brown, .darkGray, .lightGray, .cyan]
        static let icons: [String] = ["smiley", "line.horizontal.3.circle.fill", "bookmark.fill", "key.fill", "gift.fill", "phone.bubble.left.fill"]
    }
}

final class AddListVC: UIViewController, ShowAlert {

    var delegate: ReminderDelegate?
    var reminderLists: [ReminderList] = []
    var selectedColor: UIColor = Constant.colors[4]
    var selectedIcon: String = Constant.icons[1]

    @IBOutlet private weak var mainIconImage: UIImageView!
    @IBOutlet private weak var listName: UITextField!
    @IBOutlet private weak var iconsCollectionView: UICollectionView!
    @IBOutlet private weak var colorsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneAction(_ sender: Any) {
        // If list name is blank, show error
        guard let listname = listName.text, !listname.isEmpty else {
            showError(alertTitle: Constant.Alert.listNameAlertTitle, alertActionTitle: Constant.Alert.listNameAlertAction, alertMessage: Constant.Alert.listNameBlankAlertMessage, ownerVC: self)
            return
        }

        // If list name already exists, show error
        for reminderList in reminderLists {
            if reminderList.name == listname {
                showError(alertTitle: Constant.Alert.listNameAlertTitle, alertActionTitle: Constant.Alert.listNameAlertAction, alertMessage: Constant.Alert.listNameExistsAlertMessage, ownerVC: self)
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

// MARK: - UICollectionViewDelegate
extension AddListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView {
            selectedColor = Constant.colors[indexPath.row]
            listName.textColor = selectedColor
            mainIconImage.tintColor = selectedColor
            colorsCollectionView.reloadData()
        } else {
            selectedIcon = Constant.icons[indexPath.row]
            mainIconImage.image = UIImage(systemName: selectedIcon)

        }
    }
}

// MARK: - UICollectionViewDataSource
extension AddListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == colorsCollectionView ? Constant.colors.count : Constant.icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == colorsCollectionView {
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.ColorCellID, for: indexPath) as? IconCellCollectionViewCell else { return .init() }

            cell.iconImage.tintColor = Constant.colors[indexPath.row]
            if selectedColor == Constant.colors[indexPath.row] {
                cell.iconImage.layer.borderWidth = Constant.IconImage.borderWidthActive
                cell.iconImage.layer.borderColor = UIColor.lightGray.cgColor
                cell.iconImage.layer.cornerRadius = Constant.IconImage.borderCorner
            } else {
                cell.iconImage.layer.borderWidth = Constant.IconImage.borderWidthDeactive
            }
            return cell
        } else {
            guard let cell = iconsCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.IconCellID, for: indexPath) as? IconCellCollectionViewCell else { return .init() }

            cell.iconImage.image = UIImage(systemName: Constant.icons[indexPath.row])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constant.Cell.cellSize, height: Constant.Cell.cellSize)
    }
}
