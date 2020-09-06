//
//  StoreListHeader.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/4/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.

import UIKit

class StoreListHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: self)
    
    var addButton: UIButton?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addButton = UIButton()
        contentView.addSubview(addButton!)
        
        addButton?.translatesAutoresizingMaskIntoConstraints = false
        
        addButton?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addButton?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        addButton?.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        addButton?.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
