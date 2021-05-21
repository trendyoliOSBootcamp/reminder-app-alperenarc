//
//  UITextView+CenterVertically.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 14.05.2021.
//

import UIKit

extension UITextField {

    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 30.0, y: self.frame.height - 1, width: self.frame.width - 30, height: 2.0)
        bottomLine.backgroundColor = UIColor.systemGray6.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
