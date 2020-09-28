//
//  StoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class StoreViewController: UITableViewController {
    var store = Store()
    var imagePicker: ImagePicker!
    
    var currImageView: UIImageView?
    
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
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .black
        tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        closeAddCells()
    }
    
    @objc func refreshTableData() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func addItemHeader(sender: UIButton){
        closeAddCells()
        
        if let header = sender.superview?.superview as? StoreListHeader {
            let section = header.tag
            store.categories[section].toAdd = true
            currImageView = nil
        }
        tableView.reloadData()
    }
    
    @objc func tappedImage(sender: UIGestureRecognizer){
        if let imageView = sender.view as? UIImageView {
            currImageView = imageView
            imagePicker.present(from: imageView)
        }
    }
    
    func closeAddCells() {
        collapseItemCells()
        store.categories.forEach { c in
            c.toAdd = false
        }
        store.save()
        tableView.reloadData()
    }
    
    func collapseItemCells(_ isExpanded: Bool = false) {
        store.categories.forEach { category in
            category.items.forEach { item in
                item.isExpanded = isExpanded
            }
        }
        store.save()
    }
    
    
    // MARK: - Start Cells
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath[1] < store.categories[indexPath[0]].items.count {
            let delete = UIContextualAction(style: .normal, title: "Delete") { [self] (action, view, completion) in
                
                self.store.categories[indexPath[0]].items.remove(at: indexPath[1])
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                self.store.save()
                
                tableView.reloadData()
                
                completion(true)
            }
            
            delete.title = "Delete"
            delete.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [delete])
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCategory = store.categories[indexPath[0]]
        if indexPath[1] < currCategory.items.count {
            store.getItem(indexPath: indexPath).isExpanded.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currCategory = store.categories[indexPath[0]]
        if indexPath[1] < currCategory.items.count {
            let item = store.getItem(indexPath: indexPath)
            
            if item.isExpandable() && item.isExpanded {
                return 115
            }
            else {
                return 40
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currCategory = store.categories[indexPath[0]]
        
        if indexPath[1] < currCategory.items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCellCollapsible
            let currItem = currCategory.items[indexPath[1]]
            
            let categoryColor = ColorManager.defaultsMap[currCategory.name] ?? ColorManager.CUSTOMGRAY
            
            cell.checkbox.delegate = self
            cell.checkbox.onTintColor = categoryColor
            cell.checkbox.onCheckColor = categoryColor
            cell.checkbox.on = currItem.isDone
            
            cell.itemLabel.text = currItem.name
            cell.descriptionLabel.text = currItem.description
            
            //cell.itemImageView.image = currItem.getImage()
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addItemCell") as! AddItemCell
            
            cell.itemTextField.attributedPlaceholder = NSAttributedString(string: "New Item", attributes: [NSAttributedString.Key.foregroundColor: ColorManager.CUSTOMGRAY])
            cell.itemTextField.text = ""
            cell.itemTextField.delegate = self
            
            let descriptionText = NSMutableAttributedString(string: "Description ", attributes: [NSAttributedString.Key.foregroundColor: ColorManager.CUSTOMGRAY])
            descriptionText.append(NSAttributedString(string: "(Optional)", attributes: [NSAttributedString.Key.obliqueness: 0.2, NSAttributedString.Key.foregroundColor: ColorManager.CUSTOMGRAY]))
            
            cell.itemDescriptionTextField.text = ""
            cell.itemDescriptionTextField.attributedPlaceholder = descriptionText
            cell.itemDescriptionTextField.delegate = self
            
            cell.itemImage.isUserInteractionEnabled = true
            cell.itemImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedImage(sender:))))
            
            cell.itemImage.layer.cornerRadius = cell.itemImage.layer.borderWidth / 2
            cell.itemImage.image = UIImage(systemName: "photo")!
            
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

extension StoreViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let cell = tableView.cellForSubview(cellSubview: textField) as? AddItemCell
        let indexPath = tableView.indexPathForCellWithSubview(cellSubview: textField)!
        let currentCategory = store.categories[indexPath[0]]
        
        //if an item is present
        if let itemName = cell?.itemTextField.text {
            
            if itemName != "" {
                let itemToAdd = Item(name: itemName)
                
                if let description = cell?.itemDescriptionTextField.text {
                    itemToAdd.description = description
                }
                
                if let image = cell?.itemImage.image {
                    itemToAdd.imageString = image.getB64String()
                }
                
                store.addItem(category: currentCategory.name, item: itemToAdd)
                currentCategory.toAdd = false
                tableView.reloadData()
                textField.resignFirstResponder()
            }
        } else {
            DispatchQueue.main.async {
                cell?.itemTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
}

extension UITableView {
    func cellForSubview(cellSubview: UIView) -> UITableViewCell? {
        if let ip = indexPathForCellWithSubview(cellSubview: cellSubview) {
            return cellForRow(at: ip)
        }
        return nil
    }
    func indexPathForCellWithSubview(cellSubview: UIView) -> IndexPath? {
        let cellFrame = convert(cellSubview.bounds, from: cellSubview)
        let cellCenter = CGPoint(x: cellFrame.midX, y: cellFrame.midY)
        
        return indexPathForRow(at: cellCenter)
        
    }
}

extension StoreViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if let indexPath = tableView.indexPathForCellWithSubview(cellSubview: checkBox){
            let item = store.categories[indexPath[0]].items[indexPath[1]]
            item.isDone = checkBox.on
            store.save()
        }
    }
}

extension StoreViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        
        if let iv = currImageView {
            iv.image = image
            iv.layer.cornerRadius = self.currImageView?.bounds.width ?? 10 / 2
            
        }
    }
}
