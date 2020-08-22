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
    
    let GRAYCOLOR = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    var defaults = [
        ["Veggies", UIColor(red: 0.40, green: 0.77, blue: 0.40, alpha: 1.00)],
        ["Fruits", UIColor(red: 0.96, green: 0.60, blue: 0.00, alpha: 1.00)],
        ["Meats", UIColor(red: 0.93, green: 0.11, blue: 0.14, alpha: 1.00)],
        ["Dairy", UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)],
        ["Bread", UIColor(red: 0.81, green: 0.36, blue: 0.21, alpha: 1.00)],
        ["Snacks", UIColor(red: 0.00, green: 0.57, blue: 0.68, alpha: 1.00)],
        ["Cleaning Supplies", UIColor(red: 1.00, green: 0.78, blue: 0.00, alpha: 1.00)],
        ["Beauty", UIColor(red: 0.99, green: 0.38, blue: 0.66, alpha: 1.00)],
        ["Baking", UIColor(red: 0.61, green: 0.46, blue: 0.325, alpha: 1)],
        ["Frozen Foods", UIColor(red: 0.54, green: 0.82, blue: 0.86, alpha: 1.00)]
    ]
    
    var selectedCategories = Set<String>()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        toolbarView.addSeparator(at: .top, color: #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1), weight: 1.0, insets: .zero)
        storeField.inputAccessoryView = toolbarView
        
        storeField.attributedPlaceholder = NSAttributedString(string: "New List", attributes: [NSAttributedString.Key.foregroundColor: GRAYCOLOR])
        
        toolbarView.add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addList)))
        
        self.categoriesCollection.dataSource = self
        self.categoriesCollection.delegate = self
        self.categoriesCollection.alwaysBounceVertical = true
        self.categoriesCollection.backgroundColor = .white
        
        let layout = CategoryFlowLayout(minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        self.categoriesCollection.collectionViewLayout = layout
        self.categoriesCollection.collectionViewLayout.invalidateLayout()
        
        self.defaults.forEach { cat in
            self.selectedCategories.insert((cat[0] as! String).lowercased())
        }
        
    }
    
    @objc func addList() {
        
        print("hello mens")
        dismiss(animated: true, completion: nil)
    }
    
    func toggleCellColor(indexPath: IndexPath, status: Bool) {
        let cell = categoriesCollection.cellForItem(at: indexPath) as! CategoryCell
        
        toggleCellColor(cell: cell, indexPath: indexPath, status: status)
    }
    
    func toggleCellColor(cell: CategoryCell, indexPath: IndexPath, status: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            //make color
            if(status){
                cell.label.textColor = .white
                
                cell.contentView.layer.backgroundColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
                cell.contentView.layer.borderColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
            } else {
                cell.label.textColor = self.GRAYCOLOR
                cell.contentView.layer.backgroundColor = UIColor.white.cgColor
                
                cell.contentView.layer.borderColor = self.GRAYCOLOR.cgColor
                cell.contentView.layer.borderWidth = 1.5
            }
        })
    }
}

extension AddStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaults.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.item < defaults.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
            let data = self.defaults[indexPath.item][0] as! String
            
            cell.label.text = data.capitalized
            cell.label.textColor = .white
            
            cell.contentView.layer.cornerRadius = 14.0
            
            
            cell.checkbox.onTintColor = (self.defaults[indexPath.item][1]  as! UIColor)
            cell.checkbox.onCheckColor = (self.defaults[indexPath.item][1]  as! UIColor)
            cell.checkbox.onFillColor = .white
            
            cell.checkbox.offFillColor = .white
            cell.checkbox.isUserInteractionEnabled = false
            
            if(selectedCategories.contains(data.lowercased())){
                cell.contentView.layer.backgroundColor = (self.defaults[indexPath.item][1]  as! UIColor).cgColor
            }
            
            cell.checkbox.onAnimationType = .oneStroke
            cell.checkbox.offAnimationType = .fade
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addStoreCell", for: indexPath) as! AddStoreCell
            
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "Add New Category", attributes: [NSAttributedString.Key.foregroundColor: GRAYCOLOR])
            cell.textfield.textColor = GRAYCOLOR
            cell.textfield.inputAccessoryView = toolbarView
            cell.textfield.delegate = self
            
            cell.contentView.addDashedBorder(color: GRAYCOLOR)
            cell.contentView.layer.cornerRadius = 14.0
            
            return cell
        }
    }
}

extension AddStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.item < defaults.count){
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            cell.checkbox.setOn(!cell.checkbox.on, animated: true)
            toggleCellColor(indexPath: indexPath, status: cell.checkbox.on)
            
            if let text = cell.label.text {
                if(cell.checkbox.on) {
                    selectedCategories.insert(text)
                } else {
                    selectedCategories.remove(text)
                }
            }
            print(selectedCategories)
        }
    }
}

extension AddStoreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = categoriesCollection.cellForItem(at: IndexPath(row: defaults.count, section: 0)) as! AddStoreCell
        
        cell.contentView.removeDashedBorder()
        
        let currentCategories = Set(defaults.map { x in (x[0] as! String).lowercased() })
        
        if let text = textField.text  {
            if (currentCategories.contains(text.lowercased()) || text.count > 32) {
                cell.contentView.addDashedBorder(color: .red)
            }
            else {
                defaults.append([text.lowercased(), GRAYCOLOR])
                selectedCategories.insert(text.lowercased())
                categoriesCollection.reloadData()
                cell.contentView.addDashedBorder(color: GRAYCOLOR)
            }
            
            textField.text = ""
        }
        
        textField.becomeFirstResponder()
        return true
    }
    
}

final class CategoryFlowLayout: UICollectionViewFlowLayout {
    
    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }
        
        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        
        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Set the initial left inset
            var leftInset = sectionInset.left
            
            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }
        
        return layoutAttributes
    }
}
