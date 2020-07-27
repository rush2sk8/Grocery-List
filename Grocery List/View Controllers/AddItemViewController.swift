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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.largeTitleDisplayMode = .never
        
        addImageBtn.layer.cornerRadius = 10
        addImageBtn.layer.borderWidth = 3
        addImageBtn.layer.borderColor = #colorLiteral(red: 0.9921568627, green: 0, blue: 0.4274509804, alpha: 1)
        addImageBtn.clipsToBounds = true
        
        tableView.delegate = self 
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        textField.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //if we are editing an item
        if(editMode) {
            textField.text = itemToEdit
            
            if let categoryRow =  store!.categories.firstIndex(where: {$0.name == itemCategory}) {
                selectedCategory = categoryRow
            }
            
            navigationItem.title = "Edit Item"
            addButton.title = "Edit Item"
            
            addImageBtn.layer.backgroundColor = UIColor.gray.cgColor
            addImageBtn.isEnabled = false
            
            if(item.hasImage){
                addImageBtn.setImage(item.getGreyImage(), for: .normal)
            }
            
            addImageBtn.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        } else{
            navigationItem.title = "Add Item"
            addButton.title = "Add Item"
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //show the image picker
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    //add an item or edit an item
    @IBAction func addItem(_ sender: Any) {
        if(!textField.text!.isEmpty && selectedCategory != nil){
            
            let category = store!.categories[self.selectedCategory!]
            
            if(editMode) {
                
                if category.name != itemCategory {
                    
                    store?.deleteItem(category: itemCategory, item: item)
                    let newItem = item.hasImage ? Item(name: textField.text!.capitalized, isFave: item.isFavorite, imageString: item.imageString!, isDone: item.isDone) : Item(name: textField.text!.capitalized, isFave: item.isFavorite, isDone: item.isDone)
                    store?.addItem(category: (store?.categories[self.selectedCategory!])!, item: newItem)
                    
                }
                else {
                    
                    if let row = store!.categories[self.selectedCategory!].getItems().firstIndex( where: {$0 == itemToEdit}){
                        store!.editItem(category: category, itemIndex: row, newItemName: textField.text!.capitalized)
                    }
                }
            }
            
            else {
                let toAdd = Item(name: textField.text!.capitalized)
                
                if let image = addImageBtn.backgroundImage(for: .normal) {
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCategory = indexPath.row
        
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        return indexPath
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}

extension AddItemViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.addImageBtn.setBackgroundImage(image, for: .normal)
        self.addImageBtn.imageView?.layer.cornerRadius = 10
        self.addImageBtn.setImage(nil, for: .normal)
    }
}
