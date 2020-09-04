//
//  StoreListHeader.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/4/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoreListHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
