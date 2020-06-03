//
//  TableController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class TableController: UITableViewController{
    
    @IBOutlet var table: UITableView!
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    
     
        categories.append(Category(name: "Produce", items: ["Bananas", "Eggs"]))
        categories.append(Category(name: "Meats", items: ["Beef", "Chicken"]))
        // var store: Store = Store(name: "wegmans", categories: self.categories)
        
        // let encodedData = try! JSONEncoder().encode(store)
        // let ston = String(data: encodedData, encoding: .utf8)!
         
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].collapsed ? 0 : categories[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = categories[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(categories[section].collapsed)
        
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = categories[indexPath.section].items[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
  
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //index path [category index, item number]
 
        if(editingStyle == .delete){
        categories[indexPath[0]].items.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
}

extension TableController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !categories[section].collapsed
        
        categories[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
