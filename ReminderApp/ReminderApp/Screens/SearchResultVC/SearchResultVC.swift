//
//  SearchResultVCViewController.swift
//  ReminderApp
//
//  Created by Alperen Arıcı on 16.05.2021.
//

import UIKit

extension SearchResultVC {
    enum Constant {
        static let searchCellID = "searchCellID"
    }
}

final class SearchResultVC: UIViewController {

    var reminderList: [ReminderList] = []
    var searchText: String?

    @IBOutlet weak var searchTableView: UITableView!
    
    var delegate: ReminderProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
