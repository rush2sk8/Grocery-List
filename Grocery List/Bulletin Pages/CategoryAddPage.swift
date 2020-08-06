//
//  CategoryAddPage.swift
//  Grocery ListUITests
//
//  Created by Rushad Antia on 8/5/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit
import BLTNBoard

//This code is horrible and usually i would never write stuff like this
class CategoryAddPage: BLTNPageItem {
    
    public var buttons = [BulletinButton]()
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 5) 

        let defaults = [
            "Vegetables",
            "Fruits",
            "Bread",
            "Meats",
            "Dairy",
            "Cleaning Supplies",
            "Snacks",
            "Baking",
            "Beauty",
            "Frozen Foods"
        ]
        
        for category in defaults {
            let container = createChoiceCell(title: category, isSelected: true)
            container.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            stack.addArrangedSubview(container)
            buttons.append(container)
            
            container.layer.borderColor =  appearance.actionButtonColor.cgColor
            container.setTitleColor(appearance.actionButtonColor, for: .normal)
            container.accessibilityTraits.insert(.selected)
        }
        
        return [stack]
    }
    

    @objc func buttonTapped(sender: BulletinButton){
        sender.tapped.toggle()
        
        if(sender.tapped){
            sender.layer.borderColor =  appearance.actionButtonColor.cgColor
            sender.setTitleColor(appearance.actionButtonColor, for: .normal)
            sender.accessibilityTraits.insert(.selected)
        }
        else {
            sender.layer.borderColor = UIColor.lightGray.cgColor
            sender.setTitleColor(UIColor.lightGray, for: .normal)
            sender.accessibilityTraits.remove(.selected)
        }
    }
  
    func createChoiceCell(title: String, isSelected: Bool) -> BulletinButton {
        
        let button = BulletinButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        
        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }
        
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor
        
        return button
        
    }

}

class BulletinButton: UIButton {
    var tapped = true
}
