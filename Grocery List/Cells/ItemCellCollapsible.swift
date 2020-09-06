//
//  ItemCellCollapsible.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/6/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.

import Lightbox
import UIKit
import BEMCheckBox

class ItemCellCollapsible: UITableViewCell {

    @IBOutlet var checkbox: BEMCheckBox!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
