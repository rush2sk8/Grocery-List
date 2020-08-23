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
import BLTNBoard

class TableController: UITableViewController {
    
    var store = Store()
    var isCollapsed = false
    let vc = VoiceOverlayController()
    
    var bulletinManager: BLTNItemManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = store.name.capitalized
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        
        //add share list bar item
        let shareBar = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(TableController.userDidTapShare))
        self.navigationItem.rightBarButtonItem = shareBar
        
        //collapse items on tapping the bar
        let barTap = UITapGestureRecognizer(target: self, action: #selector(didTapBar))
        self.navigationController?.navigationBar.addGestureRecognizer(barTap)
        
        //add pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = .white
        self.tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
            tableView.reloadData()
        }
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: "cell")
        
        //setup voice controller
        vc.settings.autoStart = true
        vc.settings.autoStop = true
        vc.settings.autoStopTimeout = 1
        
        vc.settings.showResultScreen = false
        
        vc.settings.layout.inputScreen.subtitleBulletList = ["Add item [under] [category name]", "Add item [category] [category name]"]
        vc.settings.layout.inputScreen.titleListening = "Listening for item"
        vc.settings.layout.permissionScreen.backgroundColor = .red
        
        self.tableView.separatorColor = .clear
        self.tableView.tableFooterView = UIView()
        
    }
    
    //action for when a user is done shopping
    @IBAction func finishShopping() {
        bulletinManager = BLTNItemManager(rootItem: makeFinishShoppingBulletin())
        bulletinManager!.backgroundViewStyle = .blurredDark
        bulletinManager!.showBulletin(above: self)
        
    }
    
    func makeFinishShoppingBulletin() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Finished shopping?")
        
        page.isDismissable = true
        page.descriptionText = "Enter a Store Name"
        
        page.appearance.actionButtonColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.alternativeButtonTitleColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        page.appearance.titleTextColor = .white
        
        if store.getNumNonDoneItems() == 0 {
            page.descriptionText = "Are you sure?"
        }
        else {
            page.descriptionText = "Your list still has \(store.getNumNonDoneItems()) items left"
        }
        
        page.actionButtonTitle = "Yes"
        page.alternativeButtonTitle = "Cancel"
        
        page.isDismissable = true
        
        page.actionHandler = { item in
            self.store.finishShopping()
            self.tableView.reloadData()
            self.bulletinManager?.dismissBulletin(animated: true)
        }
        
        page.alternativeHandler = { item in
            self.bulletinManager?.dismissBulletin(animated: true)
        }
        
        return page
    }
    
    //add an item button click
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "toAdd", sender: self.store)
    }
    
    //add an item with the voice controller
    @IBAction func addItemVoice(_ sender: Any) {
        self.vc.start(on: self, textHandler: { (text, final, o) in
            print(text)
            if final {
                
                self.store.addItemFromVoiceString(text)
                
                self.tableView.reloadData()
                
            }
        }, errorHandler: { (error) in
            print(error ?? "Error")
        })
    }
    
    //refresh all the data in the table on pull
    @objc func refreshTableData() {
        if let savedStore = DataStore.getStoreData(store: store) {
            self.store = savedStore
            self.tableView.reloadData()
        }
        
        var paths: [IndexPath] = [IndexPath]()
        
        for i in 0..<store.categories.count {
            let count = tableView.numberOfRows(inSection: i)
            paths.append(contentsOf: (0..<count).map { IndexPath(row: $0, section: i)})
        }
        
        self.tableView.reloadRows(at: paths, with: .left)
        refreshControl?.endRefreshing()
    }
    
    //collapse or dont collapse all items
    @objc func didTapBar(){
        for c in self.store.categories {
            c.collapsed = self.isCollapsed
        }
        self.isCollapsed.toggle()
        tableView.reloadData()
    }
    
    //function to export list to share
    @objc func userDidTapShare() {
        let url = self.store.exportToURL()
        
        let activity = UIActivityViewController(activityItems: ["Here is my list for \(self.store.name)", url!], applicationActivities: nil)
        
        present(activity, animated: true, completion: nil)
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
    
    //resave store on view shown and reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        delete.backgroundColor = item.isFavorite ? .gray : .systemRed
        
        //swipe action to mark item as done
        let done = UIContextualAction(style: .normal, title: "Done") { [self] (action, view, completion) in
            
            //get the selected item and toggle its "doneness"
            let item = self.store.categories[indexPath[0]].items[indexPath[1]]
            item.isDone.toggle()
            
            //if thats the last item of the section then collapse it
            if self.store.categories[indexPath[0]].getNonDoneItems() == 0 {
                let sectionHeader = tableView.headerView(forSection: indexPath.section) as! CollapsibleTableViewHeader
                sectionHeader.delegate?.toggleSection(sectionHeader, section: indexPath.section)
            }
            
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
        
        header.titleLabel.text = store.categories[section].name.capitalized
        header.titleLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        header.arrowLabel.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        let numItems = store.categories[section].getNonDoneItems()
        
        header.setCollapsed(store.categories[section].collapsed, numItems)
        
        header.section = section
        header.delegate = self
        return header
    }
    
    //header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    //style the cells
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
    
    //allow row movement
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //just save incase something happens between segues
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

