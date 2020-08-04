//
//  AddStoreBulletinPage.swift
//  Grocery List
//
//  Created by Rushad Antia on 7/29/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import BLTNBoard
import UIKit

class AddStoreBulletinPage: BLTNPageItem {
    
    @objc public var textField: UITextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Store Name", returnKey: .done, delegate: self)
        return [textField]
    }
    
    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
}

extension AddStoreBulletinPage: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == nil || textField.text!.isEmpty {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            return
        }
        
        if let existingStores = DataStore.getStoreNames(){
            if(existingStores.contains(textField.text!.lowercased().trimmingCharacters(in: .whitespaces))){
                descriptionLabel!.textColor = .red
                descriptionLabel!.text = "Store Already Exists!"
                textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                return
            }
            
        }
        textInputHandler?(self, textField.text)
    }
}
