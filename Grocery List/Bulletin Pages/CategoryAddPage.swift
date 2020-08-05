//
//  CategoryAddPage.swift
//  Grocery ListUITests
//
//  Created by Rushad Antia on 8/5/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit
import BLTNBoard


class CategoryAddPage: BLTNPageItem {
    
    private var categoryButtons: [UIButton?] = []
    
    override func tearDown() {
        
        categoryButtons.forEach({ button in
            button?.removeTarget(self, action: nil, for: .touchUpInside)
        })
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        self.categoryButtons = [UIButton]()
        
        let stack = interfaceBuilder.makeGroupStack(spacing: 10)
        
        let scrollView = UIScrollView()
        scrollView.addSubview(stack)
        
        let categories =      ["Vegetables",
                               "Fruits",
                               "Bread",
                               "Meats",
                               "Dairy",
                               "Cleaning Supplies",
                               "Snacks",
                               "Baking",
                               "Beauty",
                               "Frozen Foods",
                               "Other"]
        
        for category in categories {
            let buttonContainer = createChoiceCell(title: category, isSelected: false)
            buttonContainer.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(buttonContainer)
            self.categoryButtons.append(buttonContainer)
        }
        
        return [stack]
        
    }
    
    @objc func buttonTapped(_ x: Int) {
        print("tapepd")
    }
    
    func createChoiceCell(title: String, isSelected: Bool) -> UIButton {
        
        let button = UIButton(type: .system)
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
        
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor
        
        return button
        
    }
    
    override func actionButtonTapped(sender: UIButton) {
        
        print("tapped \(String(describing: sender.titleLabel))")
        
    }
    
}

