//
//  StoresTableViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoresTableViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    var stores: [Store] = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Stores"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.reloadStores()
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
       
        let addBar = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addStoreAction))
        self.navigationItem.rightBarButtonItem = addBar
        
        self.tableView.separatorColor = .clear
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func addStoreAction(){
        showAddStoreDialog()
    }
    
    @objc func refreshTableData() {
        reloadStores()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    //just reload the store names from the userdefaults
    func reloadStores() {
        if let storeNames = DataStore.getStoreNames() {
       
            self.stores = [Store]()
            
            for storeName in storeNames {
                stores.append(Store(name: storeName))
            }
        }
        tableView.reloadData()
    }

    //shows the popup dialog to add a store
    func showAddStoreDialog(){
        let alert = UIAlertController(title: "Store Name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Store Name"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default , handler: { (action) in
            if let storeName = alert.textFields?.first?.text?.lowercased() {
                
                //if the field is left blank
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
        
        //show the alert
        self.present(alert, animated: true)
    }
    
    //error if they try to add the same store twice
    func showAddStoreAlertErrorDialog(storeName: String) {
        let alert = UIAlertController(title: "Store could not be added", message: "\(storeName.capitalized) already exists", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //hide the toolbar on view appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
        reloadStores()
    }
    
    //only 1 section in the list
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    //style each store cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as! StoreCell
        
        cell.storeLabel?.text = stores[indexPath[1]].name.capitalized
        cell.storeLabel?.font = UIFont.init(name: "Avenir-Medium", size: 30)
        return cell
    }
    
    //method to allow editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //method that will handle cell deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
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
    
    //if they select the row then perform a segue to that list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toList", sender: indexPath[1])
    }
    
    //setup segue movement
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TableController {
            let vc = segue.destination as? TableController
            let store = stores[(sender as? Int)!]
            vc?.store = store
        }
    }
}
