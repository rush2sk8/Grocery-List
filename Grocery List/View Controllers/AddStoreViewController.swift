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
    @IBOutlet private var toolbarView: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        toolbarView.addSeparator(at: .top, color: #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1), weight: 1.0, insets: .zero)
        storeField.inputAccessoryView = toolbarView
        
    }
}
