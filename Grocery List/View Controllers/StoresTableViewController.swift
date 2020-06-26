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
        
        self.reloadStores()
        
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
    }
    
    @objc func refreshTableData() {
        reloadStores()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func reloadStores() {
        if let storeNames = DataStore.getStoreNames() {
       
            self.stores = [Store]()
            
            for storeName in storeNames {
                stores.append(Store(name: storeName))
            }
        }
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
            if let storeName = alert.textFields?.first?.text?.lowercased() {
                
                if(storeName == ""){
                    return
                }
                
                //if the store exists then dont add it
                if let existingStores = DataStore.getStoreNames(){
                    if(existingStores.contains(storeName)){
                        self.showAddStoreAlertErrorDialog(storeName: storeName)
                        return
                    }
                }
                
                //save store name
                DataStore.saveNewStore(store: storeName)
                self.stores.append(Store(name: storeName))
                
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    //error if they try to add the same store twice
    func showAddStoreAlertErrorDialog(storeName: String) {
        let alert = UIAlertController(title: "Store could not be added", message: "\(storeName.capitalized) already exists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showMergedAlert(storeName: String){
        let alert = UIAlertController(title: "Successfully imported data", message: "New \(storeName.capitalized) data has been merged", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func reloadData() {
        if let storeNames = DataStore.getStoreNames() {
            for storeName in storeNames {
                stores.append(Store(name: storeName))
            }
        }
        tableView.reloadData()
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
        
        cell.textLabel?.text = stores[indexPath[1]].name.capitalized
        cell.textLabel?.font = UIFont.init(name: "Avenir-Medium", size: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //index path [category index, item number]
        
        if(editingStyle == .delete){
            
            let toRemove = stores[indexPath[1]]
            DataStore.deleteStore(store: toRemove)
            stores.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            DataStore.saveStores(stores: stores)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toList", sender: indexPath[1])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TableController {
            let vc = segue.destination as? TableController
            let store = stores[(sender as? Int)!]
            vc?.store = store
            
        }
    }
}
