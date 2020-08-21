//
//  AddStoreViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 8/17/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit

class AddStoreViewController: UIViewController {

    
    @IBOutlet private var storeField: UITextField!
    @IBOutlet private var toolbarView: ToolBarView!
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    let defaults = [
        "Vegetables",
        "Fruits",
        "Bread",
        "Meats",
        "Dairy",
        "Cleaning Supplies",
        "Snacks",
        "Baking",
        "Beauty",
        "Frozen Foods"
    ]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        toolbarView.addSeparator(at: .top, color: #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1), weight: 1.0, insets: .zero)
        storeField.inputAccessoryView = toolbarView
        
        storeField.attributedPlaceholder = NSAttributedString(string: "New List", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        toolbarView.add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addList)))
   
        self.categoriesCollection.dataSource = self
        self.categoriesCollection.delegate = self
        self.categoriesCollection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        self.categoriesCollection.alwaysBounceVertical = true
        self.categoriesCollection.backgroundColor = .white
    }
    
    @objc func addList() {
        
        
    }

}

extension AddStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        let data = self.defaults[indexPath.item]
        cell.textLabel.text = String(data)
        
        return cell
    }
}

extension AddStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
