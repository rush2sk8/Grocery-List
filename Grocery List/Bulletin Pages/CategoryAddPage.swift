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
    
    private var veggies_btn: BulletinButton!
    private var fruits_btn: BulletinButton!
    private var bread_btn: BulletinButton!
    private var meats_btn: BulletinButton!
    private var dairy_btn: BulletinButton!
    private var cleaning_btn: BulletinButton!
    private var snacks_btn: BulletinButton!
    private var baking_btn: BulletinButton!
    private var beauty_btn: BulletinButton!
    private var frozenf_btn: BulletinButton!
    
    public var store: Store?
    
    private var buttons = [BulletinButton]()
    
    private var selectedCategories: [Category] = [Category]()
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 5) 

        let vContainer = createChoiceCell(title: "Veggies", isSelected: false)
        vContainer.addTarget(self, action: #selector(veggiesTapped), for: .touchUpInside)
        stack.addArrangedSubview(vContainer)
        veggies_btn = vContainer
        buttons.append(veggies_btn)
        
        let fContainer = createChoiceCell(title: "Fruits", isSelected: false)
        fContainer.addTarget(self, action: #selector(fruitsTapped), for: .touchUpInside)
        stack.addArrangedSubview(fContainer)
        fruits_btn = fContainer
        buttons.append(fruits_btn)
        
        let bContainer = createChoiceCell(title: "Bread", isSelected: false)
        bContainer.addTarget(self, action: #selector(breadTapped), for: .touchUpInside)
        stack.addArrangedSubview(bContainer)
        bread_btn = bContainer
        buttons.append(bread_btn)
        
        let mContainer = createChoiceCell(title: "Meats", isSelected: false)
        mContainer.addTarget(self, action: #selector(meatsTapped), for: .touchUpInside)
        stack.addArrangedSubview(mContainer)
        meats_btn = mContainer
        buttons.append(meats_btn)
        
        let dContainer = createChoiceCell(title: "Dairy", isSelected: false)
        dContainer.addTarget(self, action: #selector(dairyTapped), for: .touchUpInside)
        stack.addArrangedSubview(dContainer)
        dairy_btn = dContainer
        buttons.append(dairy_btn)
        
        let cContainer = createChoiceCell(title: "Cleaning Supplies", isSelected: false)
        cContainer.addTarget(self, action: #selector(cleaningTapped), for: .touchUpInside)
        stack.addArrangedSubview(cContainer)
        cleaning_btn = cContainer
        buttons.append(cleaning_btn)
        
        let snContainer = createChoiceCell(title: "Snacks", isSelected: false)
        snContainer.addTarget(self, action: #selector(snacksTapped), for: .touchUpInside)
        stack.addArrangedSubview(snContainer)
        snacks_btn = snContainer
        buttons.append(snacks_btn)
        
        let bbContainer = createChoiceCell(title: "Baking", isSelected: false)
        bbContainer.addTarget(self, action: #selector(bakingTapped), for: .touchUpInside)
        stack.addArrangedSubview(bbContainer)
        baking_btn = bbContainer
        buttons.append(baking_btn)
        
        let beContainer = createChoiceCell(title: "Beauty", isSelected: false)
        beContainer.addTarget(self, action: #selector(beautyTapped), for: .touchUpInside)
        stack.addArrangedSubview(beContainer)
        beauty_btn = beContainer
        buttons.append(beauty_btn)
        
        let ffContainer = createChoiceCell(title: "Frozen Food", isSelected: false)
        ffContainer.addTarget(self, action: #selector(frozenTapped), for: .touchUpInside)
        stack.addArrangedSubview(ffContainer)
        frozenf_btn = ffContainer
        buttons.append(frozenf_btn)
        
        //style buttons to on
        for btn in buttons {
            btn.layer.borderColor =  appearance.actionButtonColor.cgColor
            btn.setTitleColor(appearance.actionButtonColor, for: .normal)
            btn.accessibilityTraits.insert(.selected)
        }
        
        return [stack]
    }
    
    // MARK: - Selectors setup
    
    @objc func veggiesTapped() {
        veggies_btn.tapped.toggle()
        
        if(veggies_btn.tapped){
            veggies_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            veggies_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            veggies_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            veggies_btn?.layer.borderColor = UIColor.lightGray.cgColor
            veggies_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            veggies_btn?.accessibilityTraits.remove(.selected)
        }

        print("veggies")
    }
    
    @objc func fruitsTapped() {
        fruits_btn.tapped.toggle()
        
        if(fruits_btn.tapped){
            fruits_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            fruits_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            fruits_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            fruits_btn?.layer.borderColor = UIColor.lightGray.cgColor
            fruits_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            fruits_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("fruits_btn")
    }
    
    @objc func breadTapped() {
        bread_btn.tapped.toggle()
        
        if(bread_btn.tapped){
            bread_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            bread_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            bread_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            bread_btn?.layer.borderColor = UIColor.lightGray.cgColor
            bread_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            bread_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("bread_btn")
    }
   
    @objc func meatsTapped() {
        meats_btn.tapped.toggle()
        
        if(meats_btn.tapped){
            meats_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            meats_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            meats_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            meats_btn?.layer.borderColor = UIColor.lightGray.cgColor
            meats_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            meats_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("meats_btn")
    }
    
    @objc func dairyTapped() {
        dairy_btn.tapped.toggle()
        
        if(dairy_btn.tapped){
            dairy_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            dairy_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            dairy_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            dairy_btn?.layer.borderColor = UIColor.lightGray.cgColor
            dairy_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            dairy_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("dairy_btn")
    }
    
    @objc func cleaningTapped() {
        cleaning_btn.tapped.toggle()
        
        if(cleaning_btn.tapped){
            cleaning_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            cleaning_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            cleaning_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            cleaning_btn?.layer.borderColor = UIColor.lightGray.cgColor
            cleaning_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            cleaning_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("cleaning_btn")
    }
    
    @objc func snacksTapped() {
        snacks_btn.tapped.toggle()
        
        if(snacks_btn.tapped){
            snacks_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            snacks_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            snacks_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            snacks_btn?.layer.borderColor = UIColor.lightGray.cgColor
            snacks_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            snacks_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("snacks_btn")
    }
    
    @objc func bakingTapped() {
        baking_btn.tapped.toggle()
        
        if(baking_btn.tapped){
            baking_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            baking_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            baking_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            baking_btn?.layer.borderColor = UIColor.lightGray.cgColor
            baking_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            baking_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("baking_btn")
    }
    
    @objc func beautyTapped() {
        beauty_btn.tapped.toggle()
        
        if(beauty_btn.tapped){
            beauty_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            beauty_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            beauty_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            beauty_btn?.layer.borderColor = UIColor.lightGray.cgColor
            beauty_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            beauty_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("beauty_btn")
    }
    
    @objc func frozenTapped() {
        frozenf_btn.tapped.toggle()
        
        if(frozenf_btn.tapped){
            frozenf_btn?.layer.borderColor =  appearance.actionButtonColor.cgColor
            frozenf_btn?.setTitleColor(appearance.actionButtonColor, for: .normal)
            frozenf_btn?.accessibilityTraits.insert(.selected)
        }
        else {
            frozenf_btn?.layer.borderColor = UIColor.lightGray.cgColor
            frozenf_btn?.setTitleColor(UIColor.lightGray, for: .normal)
            frozenf_btn?.accessibilityTraits.remove(.selected)
        }
        
        print("frozenf_btn")
    }
        
    // MARK: - End Selectors
    
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

    override func actionButtonTapped(sender: UIButton) {
        
        for button in self.buttons {
            if button.tapped {
                print(button.titleLabel?.text)
            }
        }
    }
}

class BulletinButton: UIButton {
    var tapped = true
}
