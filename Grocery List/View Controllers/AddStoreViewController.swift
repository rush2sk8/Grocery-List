//
//  AddStoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 8/17/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit
import BEMCheckBox

class AddStoreViewController: UIViewController {
    
    
    @IBOutlet private var storeField: UITextField!
    @IBOutlet private var toolbarView: ToolBarView!
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    let defaults = [
        ["Vegetables", UIColor(red: 0.396, green: 0.769, blue: 0.4, alpha: 1)],
        ["Fruits", UIColor(red: 0.965, green: 0.6, blue: 0, alpha: 1)],
        ["Bread", UIColor(red: 0.75, green: 0.38, blue: 0.38, alpha: 1.00)],
        ["Meats", UIColor(red: 0.92, green: 0.31, blue: 0.24, alpha: 1.00)],
        ["Dairy", UIColor(red: 0.35, green: 0.65, blue: 0.84, alpha: 1.00)],
        ["Cleaning Supplies", UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)],
        ["Snacks", UIColor(red: 0.77, green: 0.47, blue: 0.87, alpha: 1.00)],
        ["Baking", UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)],
        ["Beauty", UIColor(red: 1.00, green: 0.45, blue: 0.85, alpha: 1.00)],
        ["Frozen Foods", UIColor(red: 0.49, green: 0.88, blue: 0.90, alpha: 1.00)]
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        toolbarView.addSeparator(at: .top, color: #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1), weight: 1.0, insets: .zero)
        storeField.inputAccessoryView = toolbarView
        
        storeField.attributedPlaceholder = NSAttributedString(string: "New List", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        toolbarView.add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addList)))
        
        self.categoriesCollection.dataSource = self
        self.categoriesCollection.delegate = self
        self.categoriesCollection.alwaysBounceVertical = true
        self.categoriesCollection.backgroundColor = .white
        
    }
    
    @objc func addList() {
        
        
    }
    
    func toggleCellColor(indexPath: IndexPath, status: Bool) {
        let cell = categoriesCollection.cellForItem(at: indexPath) as! CategoryCell
        
        //make color
        if(status){
            cell.label.textColor = .white
            
            cell.contentView.layer.cornerRadius = 14.0
            cell.contentView.layer.backgroundColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
            cell.contentView.layer.borderColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
        } else {
            cell.label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            cell.contentView.layer.backgroundColor = UIColor.white.cgColor
            cell.contentView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
            cell.contentView.layer.borderWidth = 1.5
        }
    }
    
}

extension AddStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        let data = self.defaults[indexPath.item][0] as! String
        
        cell.label.text = data
        cell.label.textColor = .white
        
        cell.contentView.layer.cornerRadius = 14.0
        cell.contentView.layer.backgroundColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
        
        cell.checkbox.onTintColor = (self.defaults[indexPath.item][1]  as! UIColor)
        cell.checkbox.onCheckColor = (self.defaults[indexPath.item][1]  as! UIColor)
        cell.checkbox.onFillColor = .white
        
        cell.checkbox.offFillColor = .white
        cell.checkbox.isUserInteractionEnabled = false
        
        return cell
    }
}

extension AddStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.checkbox.setOn(!cell.checkbox.on, animated: true)
        toggleCellColor(indexPath: indexPath, status: cell.checkbox.on)
    }
}

extension AddStoreViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
