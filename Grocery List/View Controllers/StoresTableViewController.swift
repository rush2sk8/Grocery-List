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

class StoresTableViewController: UITableViewController {
    
    var stores: [Store] = [Store]()
    
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = makeAddStoreBulletin()
        return BLTNItemManager(rootItem: introPage)
    }()
    
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
        
        self.bulletinManager.backgroundViewStyle = .blurredDark
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
    
    func makeAddStoreBulletin() -> AddStoreBulletinPage {
        
        let page = AddStoreBulletinPage(title: "Add Store")
        page.isDismissable = true
        page.descriptionText = "Enter a Store Name"
        page.actionButtonTitle = "Continue"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        page.appearance.titleTextColor = .white
        
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
            
            if let storeName = text {
                
                if let existingStores = DataStore.getStoreNames() {
                    
                    let lowercased = existingStores.map { x in x.lowercased() }
                    
                    if(lowercased.contains(storeName.lowercased().trimmingCharacters(in: .whitespaces))){
                        page.descriptionLabel!.textColor = .red
                        page.descriptionLabel!.text = "Store Already Exists!"
                        page.textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                        return
                    }
                }
                
                page.next = self.makeCategoryBulletin(storeName: storeName)
                self.bulletinManager.displayNextItem()
            }
        }
        
        return page
    }
    
    func makeCategoryBulletin(storeName: String) -> CategoryAddPage {
        
        let page = CategoryAddPage(title: "Default Categories")
        page.isDismissable = true
        page.descriptionText = "Select Defaults"
        page.actionButtonTitle = "Add Store"
        page.alternativeButtonTitle = "Add Custom Categories"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.alternativeButtonTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        page.appearance.titleTextColor = .white
        
        page.actionHandler = { (item: BLTNActionItem) in
            //save store name
            let selectedCategories = self.getCategoriesFromCardPage(page: page)
            
            if(selectedCategories.count == 0){
                page.descriptionLabel!.textColor = .red
                page.descriptionLabel!.text = "Please select atleast 1 category!"
            }
            
            else {
                let store = Store(name: storeName, selectedCategories)
        
                DataStore.saveNewStore(store: storeName)
                DataStore.saveStoreData(store: store)
                self.stores.append(store)
                self.tableView.reloadData()
                self.bulletinManager.dismissBulletin(animated: true)
            }
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            var selectedCategories = self.getCategoriesFromCardPage(page: page)
            selectedCategories.append(Category(name: "Other"))
            
            let store = Store(name: storeName, selectedCategories)
            
            page.next = self.makeCustomCategoryCard(store: store)
            self.bulletinManager.displayNextItem()
        }
        
        return page
    }
    
    private func getCategoriesFromCardPage(page: CategoryAddPage) -> [Category] {
        var selectedCategories = [Category]()
        
        for button in page.buttons {
            if button.tapped {
                print(button.titleLabel!.text!)
                selectedCategories.append(Category(name: button.titleLabel!.text!))
            }
        }
        return selectedCategories
    }
    
    func makeCustomCategoryCard(store: Store) -> AddCustomCategoryCard {
        let page = AddCustomCategoryCard(title: "Custom Category")
        page.isDismissable = true
        page.descriptionText = "Enter custom category name"
        page.actionButtonTitle = "Finish Adding Store"
        page.alternativeButtonTitle = "Add another custom category"
        page.appearance.actionButtonColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.alternativeButtonTitleColor = #colorLiteral(red: 0.9911134839, green: 0.0004280109715, blue: 0.4278825819, alpha: 1)
        page.appearance.actionButtonTitleColor = .white
        page.appearance.titleTextColor = .white
        
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
            
            let currentCategories = store.getCategories().map { p in p.lowercased() }
            
            if let categoryName = text {
                
                if(currentCategories.contains(categoryName.lowercased())){
                    page.descriptionLabel!.textColor = .red
                    page.descriptionLabel!.text = "Category already added!"
                }
                else {
                    //add the final 2 categories
                    store.addCategory(category: Category(name: categoryName))
                    store.addCategory(category: Category(name: "Other"))
                    
                    DataStore.saveNewStore(store: store.name.lowercased())
                    DataStore.saveStoreData(store: store)
                    self.stores.append(store)
                    self.tableView.reloadData()
                    self.bulletinManager.dismissBulletin(animated: true)
                }
            }
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            let currentCategories = store.getCategories().map { p in p.lowercased() }
            
            if let categoryName = page.textField.text {
                
                if(categoryName == ""){
                    page.descriptionLabel!.textColor = .red
                    page.descriptionLabel!.text = "Please enter some text!"
                    page.textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                }
                
                else if(currentCategories.contains(categoryName.lowercased())){
                    page.descriptionLabel!.textColor = .red
                    page.descriptionLabel!.text = "Category already added!"
                    page.textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                }
                
                else {
                    store.addCategory(category: Category(name: categoryName))
                    page.next = self.makeCustomCategoryCard(store: store)
                    self.bulletinManager.displayNextItem()
                }
            }
        }
        
        return page
    }
    
    //shows the popup dialog to add a store
    func showAddStoreDialog(){
        bulletinManager.showBulletin(above: self)
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
