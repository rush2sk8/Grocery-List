//
//  HomescreenViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/25/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class HomescreenViewController: UIViewController {
    
    @IBOutlet weak var storesBtn: UIButton!
    @IBOutlet weak var optionsBtn: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        storesBtn.layer.cornerRadius = 20
        optionsBtn.layer.cornerRadius = 20
    }
    
}
