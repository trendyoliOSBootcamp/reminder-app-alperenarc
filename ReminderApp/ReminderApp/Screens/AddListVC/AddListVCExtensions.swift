//
//  AddListVCExtensions.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit
extension AddListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == colorsCollectionView {
            return Constant.colors.count
        } else {
            return Constant.icons.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == colorsCollectionView {
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.ColorCellID, for: indexPath) as? IconCellCollectionViewCell else { return .init() }

            cell.iconImage.tintColor = Constant.colors[indexPath.row]
            if selectedColor == Constant.colors[indexPath.row] {
                cell.iconImage.layer.borderWidth = Constant.borderWidthActive
                cell.iconImage.layer.borderColor = UIColor.lightGray.cgColor
                cell.iconImage.layer.cornerRadius = Constant.borderCorner
            } else {
                cell.iconImage.layer.borderWidth = Constant.borderWidthDeactive
            }
            return cell
        } else {
            guard let cell = iconsCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.IconCellID, for: indexPath) as? IconCellCollectionViewCell else { return .init() }

            cell.iconImage.image = UIImage(systemName: Constant.icons[indexPath.row])
            return cell
        }
    }

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

extension AddListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 50)
    }
}
