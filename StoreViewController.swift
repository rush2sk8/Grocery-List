//
//  StoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoreViewController: UITableViewController {
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = store.name.capitalized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
    
        self.tableView.register(StoreListHeader.self, forHeaderFooterViewReuseIdentifier: StoreListHeader.reuseIdentifier)
    
    }
    
    @objc func addItemHeader(sender: UIButton){
        let header = sender.superview?.superview as! StoreListHeader
        let section = header.tag
        store.categories[section].toAdd = true
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(self.store.categories[indexPath[0]].items[indexPath[1]])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currCategory = store.categories[indexPath[0]]
        
        if indexPath[1] < currCategory.items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCellCollapsible
         
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addItemCell") as! AddItemCell
            
            return cell
        }
    }
    
    // MARK: - Start Header
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return  50.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return store.categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = store.categories[section].items.count
        return store.categories[section].toAdd ? (num + 1) : num
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreListHeader.reuseIdentifier) as? StoreListHeader else { return nil }
        
        let catName = self.store.getCategories()[section].lowercased()
        
        var color: UIColor? = ColorManager.CUSTOMGRAY
        
        if (ColorManager.defaultsMap.keys.contains(catName)) {
            color = ColorManager.defaultsMap[catName]
        }
        
        view.textLabel?.text = catName.capitalized
        view.textLabel?.textColor = color
        
        view.contentView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        view.addButton?.imageView?.tintColor = color
        view.addButton?.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
        view.addButton?.addTarget(self, action: #selector(addItemHeader(sender:)), for: .touchUpInside)
        
        view.tag = section
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? StoreListHeader {
            header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.init(rawValue: 0.600))
        }
    }
    
}
