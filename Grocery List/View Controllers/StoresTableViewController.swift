//
//  StoresTableViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoresTableViewController: UITableViewController{
    
    var stores: [Store] = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        
        // let encodedData = try! JSONEncoder().encode(store)
        // let ston = String(data: encodedData, encoding: .utf8)!
       stores.append(Store(name: "wegmans"))
        
        
    }
    
    @IBAction func addStore(_ sender: Any) {
      showAddStoreDialog()
    }
    
    func showAddStoreDialog(){
        let alert = UIAlertController(title: "Store Name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Store Name"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default , handler: { (action) in
            if let storeName = alert.textFields?.first?.text {
                self.stores.append(Store(name: storeName))
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "storeCell")
       
        cell.textLabel?.text = stores[indexPath[1]].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //index path [category index, item number]
        
        if(editingStyle == .delete){
            stores.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
