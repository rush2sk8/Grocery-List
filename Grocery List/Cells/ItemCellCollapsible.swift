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
    @IBOutlet var favoriteView: CircleView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CircleView: UIView {
    
    var circleColor: UIColor!
    var favorite: Bool!
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: CGRect(x: 2, y: 2, width: 12, height: 12))
        path.lineWidth = 1
        
        if favorite {
            circleColor.setStroke()
            circleColor.setFill()
        }
        else {
            #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).setStroke()
            #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1).setFill()
        }
        
        path.fill()
        path.stroke()
    }
}
