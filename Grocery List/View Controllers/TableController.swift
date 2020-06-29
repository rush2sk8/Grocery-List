//
//  TableController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class TableController: UITableViewController {
    
    var store = Store()
    var isCollapsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
  
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
 
        tableView.delegate = self
        
        let shareBar = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(TableController.userDidTapShare))
        self.navigationItem.rightBarButtonItem = shareBar
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        let barTap = UITapGestureRecognizer(target: self, action: #selector(didTapBar))
        self.navigationController?.navigationBar.addGestureRecognizer(barTap)
        
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
            tableView.reloadData()
        }
        updateTitle()
    }
    
    @objc func refreshTableData(){
        self.tableView.reloadData()
        self.updateTitle()
    }
    

   @objc func longPress(longpressGR: UILongPressGestureRecognizer){
        if longpressGR.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longpressGR.location(in: self.view)
            
            if let _ = tableView.indexPathForRow(at: touchPoint){
               
                //let item = store.categories[indexPath[0]].items[indexPath[1]]
                
                //performSegue(withIdentifier: "toEdit", sender: (item, self.store, store.categories[indexPath[0]].name))
            }
        }
    }
    
    @objc func didTapBar(){
        for c in self.store.categories {
                c.collapsed = self.isCollapsed
        }
        self.isCollapsed.toggle()
        tableView.reloadData()
        
    }
    
    @objc func userDidTapShare() {
        
        let url = self.store.exportToURL()
        
        let activity = UIActivityViewController(activityItems: ["Here is my list for \(self.store.name)", url!], applicationActivities: nil)
        
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "toAdd", sender: self.store)
    }
    
    func updateTitle(){
        self.navigationItem.title = self.store.getNumItems() == 0 ? "\(self.store.name.capitalized)" : "\(self.store.name.capitalized) (\(self.store.getNumItems()))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is AddItemViewController {
            let vc = segue.destination as? AddItemViewController
            
            if segue.identifier == "toAdd" {
                let s = sender as? Store
                vc?.store = s!
            }
            
            else if segue.identifier == "toEdit" {
                let s =  sender as? (String, Store, String, Item)
                vc?.store = s!.1
                vc?.itemToEdit = s!.0
                vc?.itemCategory = s!.2
                vc?.item = s!.3
                vc?.editMode = true
            }
         
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
        }
        tableView.reloadData()
        updateTitle()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { [self] (action, view, completion) in
            let item = self.store.categories[indexPath[0]].items[indexPath[1]]
            
            self.performSegue(withIdentifier: "toEdit", sender: (item.name, self.store, self.store.categories[indexPath[0]].name, item))
            completion(true)
        }
        action.title = "Edit"
        
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
        
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
        header.titleLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        header.arrowLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        let numItems = store.categories[section].items.count
        
        if numItems == 0 {
            header.arrowLabel.text = "✓"
        } else{
         
            header.setCollapsed(store.categories[section].collapsed, numItems)
        }
        
        header.section = section
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = store.categories[indexPath.section].items[indexPath.row].name
        cell.textLabel?.font = UIFont.init(name: "Avenir-Medium", size: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            store.categories[indexPath[0]].items.remove(at: indexPath[1])
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            DataStore.saveStoreData(store: self.store)
        }
        tableView.reloadData()
        updateTitle()
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
        
        if store.categories[section].items.count != 0 {
            store.categories[section].collapsed = collapsed
            header.setCollapsed(collapsed, store.categories[section].items.count )
        }
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
    }
}
