//
//  AddItem.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit


class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var store: Store?
    var selectedCategory: Int?
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Item"
        
        tableView.delegate = self 
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        textField.delegate = self
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        if(!textField.text!.isEmpty && selectedCategory != nil){
            store?.categories[self.selectedCategory!].items.append(textField.text!.capitalized)
            DataStore.saveStoreData(store: self.store!)
            navigationController?.popViewController(animated: true)
        }
        
    }

    /*TABLE VIEW STUFF*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CollapsibleTableViewCell
        cell.textLabel?.text = self.store?.categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = indexPath.row
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        background.endEditing(true)
        return true
    }
    
}
