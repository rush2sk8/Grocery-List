//
//  UIColor+RandomColor.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/4/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let r = CGFloat(arc4random_uniform(255)) / 255.0
        let g = CGFloat(arc4random_uniform(255)) / 255.0
        let b = CGFloat(arc4random_uniform(255)) / 255.0
        let alpha = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255 : 1
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
        
    }
}
