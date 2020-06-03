//
//  AddItem.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/3/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit


class AddItemViewController: UIViewController{
    
    var categories: [Category] = [Category]()
    
    override func viewDidLoad() {
        self.navigationController?.setToolbarHidden(true, animated: true)
        super.viewDidLoad()
        print(categories)
    }
    
}
