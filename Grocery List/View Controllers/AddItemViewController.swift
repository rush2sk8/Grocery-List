//
//  AddItem.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit


class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var store: Store?
    var selectedCategory: Int?
    
    var editMode = false
    var itemToEdit: String  = ""
    var itemCategory: String = ""
    var item: Item = Item()
    
    var imagePicker: ImagePicker!
    
    @IBOutlet var background: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        addImageBtn.layer.cornerRadius = 10
        
        tableView.delegate = self 
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        textField.delegate = self
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if(editMode) {
            textField.text = itemToEdit
            
            if let categoryRow =  store!.categories.firstIndex(where: {$0.name == itemCategory}) {
                selectedCategory = categoryRow
            }
            
            navigationItem.title = "Edit Item"
            addButton.title = "Edit Item"
            tableView.allowsSelection = false
            
            addImageBtn.layer.backgroundColor = UIColor.gray.cgColor
            addImageBtn.isEnabled = false
        
            if(item.hasImage){
                imageView.image = item.getGreyImage()
                imageView.layer.cornerRadius = 8.0
                imageView.clipsToBounds = true
            }
            
        } else{
            navigationItem.title = "Add Item"
            addButton.title = "Add Item"
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func addItem(_ sender: Any) {
        if(!textField.text!.isEmpty && selectedCategory != nil){
            
            let category = store!.categories[self.selectedCategory!]
            
            if(editMode) {
                
                if let row = store!.categories[self.selectedCategory!].getItems().firstIndex( where: {$0 == itemToEdit}){
                    store!.editItem(category: category, itemIndex: row, newItemName: textField.text!.capitalized)
                }
            }
                
            else {
                let toAdd = Item(name: textField.text!.capitalized)
                
                if let image = imageView.image {
                    let imageData = image.jpegData(compressionQuality: 0.3)
                    let imageb64 = imageData?.base64EncodedString()
                   
                    if let i64 = imageb64 {
                        toAdd.imageString = i64
                    }
                }
               
                store?.addItem(category: category, item: toAdd)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    /*TABLE VIEW STUFF*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store?.categories.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.store?.categories[indexPath.row].name
        cell.textLabel?.font = UIFont.init(name: "Avenir-Medium", size: 14)
        
        if(editMode){
            cell.isUserInteractionEnabled = false
            cell.textLabel?.isEnabled = false
            cell.detailTextLabel?.isEnabled = false
       
            if indexPath[1] == selectedCategory {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!editMode){
            self.selectedCategory = indexPath.row
        }
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if(!editMode){
            if let oldIndex = tableView.indexPathForSelectedRow {
                tableView.cellForRow(at: oldIndex)?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        return indexPath
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        background.endEditing(true)
        return true
    }
}

extension AddItemViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}
