//
//  StoreIconManager.swift
//  Grocery List
//
//  Created by Rushad Antia on 8/27/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit

class StoreIconManager {
    private static let colorMap: [String: UIColor] = [
        "cart.fill": #colorLiteral(red: 0.5176470588, green: 0.3921568627, blue: 0.7960784314, alpha: 1),
        "staroflife.fill": #colorLiteral(red: 0.9176470588, green: 0.3058823529, blue: 0.2392156863, alpha: 1),
        "house.fill": #colorLiteral(red: 0.2823529412, green: 0.5725490196, blue: 0.9529411765, alpha: 1),
        "desktopcomputer": #colorLiteral(red: 0.9450980392, green: 0.6039215686, blue: 0.2156862745, alpha: 1),
    ]

    static func getImageFromString(imgString: String) -> UIImage? {
        if colorMap.keys.contains(imgString) {
            return UIImage(systemName: imgString)!.withTintColor(colorMap[imgString]!)
        }

        return nil
    }

    static func getTint(imgString: String) -> UIColor? {
        if colorMap.keys.contains(imgString) {
            return colorMap[imgString]
        }
        return nil
    }
}
