//
//  TableController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchVoiceOverlay

class TableController: UITableViewController {
    
    var store = Store()
    var isCollapsed = false
    let vc = VoiceOverlayController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.title = store.name.capitalized
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        
        let shareBar = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(TableController.userDidTapShare))
        self.navigationItem.rightBarButtonItem = shareBar
        
        let barTap = UITapGestureRecognizer(target: self, action: #selector(didTapBar))
        self.navigationController?.navigationBar.addGestureRecognizer(barTap)
        
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
            tableView.reloadData()
        }
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: "cell")
        
        vc.settings.autoStart = true
        vc.settings.autoStop = true
        vc.settings.autoStopTimeout = 1
        
        vc.settings.showResultScreen = false
        
        vc.settings.layout.inputScreen.subtitleBulletList = ["Hello"]
        vc.settings.layout.inputScreen.titleListening = "Listening for item"
        vc.settings.layout.permissionScreen.backgroundColor = .red
        
    }
    
    @objc func refreshTableData() {
        
        var paths: [IndexPath] = [IndexPath]()
        
        for i in 0..<store.categories.count {
            let count = tableView.numberOfRows(inSection: i)
            paths.append(contentsOf: (0..<count).map { IndexPath(row: $0, section: i)})
        }
        
        self.tableView.reloadRows(at: paths, with: .left)
        refreshControl?.endRefreshing()
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
    
    @IBAction func addItemVoice(_ sender: Any) {
        vc.start(on: self, textHandler: { (text, final, o) in
            print(text)
            if final {
                
                self.store.addItemFromVoiceString(text)
                
                self.tableView.reloadData()
                
            }
        }, errorHandler: { (error) in
            print(error ?? "Error")
        })
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
    }
    
    //add edit functionality
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = store.categories[indexPath.section].items[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { [self] (action, view, completion) in
            if item.isFavorite == false {
                //delete the data from the thing and make it persist
                self.store.categories[indexPath[0]].items.remove(at: indexPath[1])
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                self.store.save()
                
                tableView.reloadData()
            }
            completion(true)
        }
        
        delete.title = "Delete"
        delete.backgroundColor = item.isFavorite ? .lightGray : .systemRed
        
        //swipe action to mark item as done
        let done = UIContextualAction(style: .normal, title: "Done") { [self] (action, view, completion) in
            
            //get the selected item and toggle its "doneness"
            let item = self.store.categories[indexPath[0]].items[indexPath[1]]
            item.isDone.toggle()
            
            //reload table to trigger rerender of info
            tableView.reloadData()
            
            //make the change persist
            self.store.save()
            
            completion(true)
        }
        
        done.title = "Done"
        done.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [done,delete])
    }
    
    //return number of categories in the store
    override func numberOfSections(in tableView: UITableView) -> Int {
        return store.categories.count
    }
    
    //return the number of items in the category
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.categories[section].collapsed ? 0 : store.categories[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //return the collapsible header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = store.categories[section].name
        header.titleLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        header.arrowLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        let numItems = store.categories[section].getNonDoneItems()
        
        header.setCollapsed(store.categories[section].collapsed, numItems)
        
        header.section = section
        header.delegate = self
        return header
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemCell 
        
        let item = store.categories[indexPath.section].items[indexPath.row]
        
        cell.item = item
        cell.store = self.store
        
        cell.setItemTitle()
        cell.setImageView()
        cell.setFavorite()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(self.isMovingFromParent){
            store.save()
        }
        tableView.reloadData()
    }
}

extension TableController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !store.categories[section].collapsed
        
        if store.categories[section].items.count != 0 {
            store.categories[section].collapsed = collapsed
            header.setCollapsed(collapsed, store.categories[section].getNonDoneItems())
        }
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}

