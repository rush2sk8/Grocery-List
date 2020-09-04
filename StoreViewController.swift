//
//  StoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoreViewController: UITableViewController {
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = store.name.capitalized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.store.getCategories()[section].capitalized
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return store.categories.count
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
}
