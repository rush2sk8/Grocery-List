//
//  ColorManager.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/6/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {
    static let defaultsArr = [
        ["veggies", UIColor(red: 0.40, green: 0.77, blue: 0.40, alpha: 1.00)],
        ["fruits", UIColor(red: 0.96, green: 0.60, blue: 0.00, alpha: 1.00)],
        ["meats", UIColor(red: 0.93, green: 0.11, blue: 0.14, alpha: 1.00)],
        ["dairy", UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)],
        ["bread", UIColor(red: 0.81, green: 0.36, blue: 0.21, alpha: 1.00)],
        ["snacks", UIColor(red: 0.00, green: 0.57, blue: 0.68, alpha: 1.00)],
        ["cleaning supplies", UIColor(red: 1.00, green: 0.78, blue: 0.00, alpha: 1.00)],
        ["beauty", UIColor(red: 0.99, green: 0.38, blue: 0.66, alpha: 1.00)],
        ["baking", UIColor(red: 0.61, green: 0.46, blue: 0.325, alpha: 1)],
        ["frozen foods", UIColor(red: 0.54, green: 0.82, blue: 0.86, alpha: 1.00)]
    ]
    
    static let defaultsMap: [String: UIColor] = [
        "veggies": UIColor(red: 0.40, green: 0.77, blue: 0.40, alpha: 1.00),
        "fruits": UIColor(red: 0.96, green: 0.60, blue: 0.00, alpha: 1.00),
        "meats": UIColor(red: 0.93, green: 0.11, blue: 0.14, alpha: 1.00),
        "dairy": UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00),
        "bread": UIColor(red: 0.81, green: 0.36, blue: 0.21, alpha: 1.00),
        "snacks": UIColor(red: 0.00, green: 0.57, blue: 0.68, alpha: 1.00),
        "cleaning supplies": UIColor(red: 1.00, green: 0.78, blue: 0.00, alpha: 1.00),
        "beauty": UIColor(red: 0.99, green: 0.38, blue: 0.66, alpha: 1.00),
        "baking": UIColor(red: 0.61, green: 0.46, blue: 0.325, alpha: 1),
        "frozen foods": UIColor(red: 0.54, green: 0.82, blue: 0.86, alpha: 1.00),
        "other": CUSTOMGRAY
    ]
    
    static let CUSTOMGRAY = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
}
