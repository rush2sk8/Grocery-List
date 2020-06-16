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
    
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.title = self.store.name.capitalized
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let shareBar = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(TableController.userDidTapShare))
        self.navigationItem.rightBarButtonItem = shareBar
        
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
            tableView.reloadData()
        }
    }
    
    @objc func userDidTapShare() {
        
        let url = self.store.exportToURL()
        
        let activity = UIActivityViewController(activityItems: ["Here is my grocery list", url!], applicationActivities: nil)
        
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: Any) {
        print(self.store)
        performSegue(withIdentifier: "toAdd", sender: self.store)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddItemViewController {
            let vc = segue.destination as? AddItemViewController
            let s = sender as? Store
            vc?.store = s!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return store.categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.categories[section].collapsed ? 0 : store.categories[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = store.categories[section].name
        header.arrowLabel.text = "→"
        header.setCollapsed(store.categories[section].collapsed)
        
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
     
        cell.textLabel?.text = store.categories[indexPath.section].items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //index path [category index, item number]
        
        if(editingStyle == .delete){
            store.categories[indexPath[0]].items.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            DataStore.saveStoreData(store: self.store)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(self.isMovingFromParent){
            DataStore.saveStoreData(store: self.store)
        }
    }
}

extension TableController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !store.categories[section].collapsed
        
        store.categories[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
