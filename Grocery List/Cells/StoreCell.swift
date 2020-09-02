//
//  StoreCell.swift
//  Grocery List
//
//  Created by Rushad Antia on 7/20/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class StoreCell: UITableViewCell {
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var cellImageView: UIImageView!
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = .gray
        }
    }
}

extension UIView {
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.allSubviews }
    }
}
