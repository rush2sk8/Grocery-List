//
//  StoresTableViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard

class StoresTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    var stores: [Store] = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Stores"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.reloadStores()
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .black
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        self.tableView.contentInset = .init(top: 15, left: 0, bottom: 0, right: 0)
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
    
    @IBAction func toStoreAdd(_ sender: Any) {
        performSegue(withIdentifier: "toAddStore", sender: nil)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        reloadStores()
        self.tableView.reloadData()
    }
    
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
        cell.separatorInset = .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.layoutMargins = .zero
        cell.tintColor = .black
        cell.storeLabel?.font = UIFont.init(name: "Avenir-Medium", size: 30)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.layoutMargins = .zero
        cell.contentView.superview?.backgroundColor = .white
        cell.backgroundColor = .white
        cell.tintColor = .black
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
        else if segue.destination is AddStoreViewController {
            segue.destination.presentationController?.delegate = self
            
            let vc = segue.destination as? AddStoreViewController
            vc?.parentVC = self
        }
    }
}
