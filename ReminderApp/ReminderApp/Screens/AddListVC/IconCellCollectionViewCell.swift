//
//  ColorCellCollectionViewCell.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 15.05.2021.
//

import UIKit

class IconCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
        contentView.layer.masksToBounds = true
        iconImage.layer.cornerRadius = iconImage.bounds.height / 2
        iconImage.layer.masksToBounds = true
    }
}
