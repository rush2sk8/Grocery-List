//
//  ItemCell.swift
//  Grocery List
//
//  Created by Rushad Antia on 7/9/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import UIKit
import Lightbox

class ItemCell: UITableViewCell {
    
    var item: Item?
    var parentVC: TableController?
    var starButton: UIButton?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        starButton = UIButton(type: .system)
        starButton!.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        starButton!.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        accessoryView = starButton
        
        self.starButton!.tintColor = .lightGray
    }
    
    @objc private func handleFav(){
        
        if let i = item {
            if let vc = parentVC {
                i.isFavorite.toggle()
                vc.save()
                setFavorite()
            }
        }
    }
    
    func setFavorite(){
        if let i = item {
            self.starButton!.tintColor = i.isFavorite ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) : UIColor.lightGray
        }
    }
    
    func setImageView() {
        if let i = item {
            imageView?.isUserInteractionEnabled = true
            
            if i.hasImage {
                
                let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                imageView?.addGestureRecognizer(longpressRecognizer)
                
                imageView?.image = (i.isDone ? i.getGreyImage() : i.getImage())
                imageView?.layer.cornerRadius = 8.0
                imageView?.clipsToBounds = true
                
            } else {
                imageView?.image = nil
            }
        }
    }
    
    @objc func longPress(){
        if let i = item {
            if i.hasImage {
                
                let images = [LightboxImage(image: i.getImage()!)]
                
                let controller = LightboxController(images: images)
                
                controller.dynamicBackground = true
                controller.modalPresentationStyle = .fullScreen
                
                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
                
            }
        }
    }
    
    func setItemTitle(){
        if let i = item {
            var attributedString = NSMutableAttributedString(string: i.name)
            
            //if the item is marked as done then make the string strikedthrough
            if i.isDone {
                attributedString = NSMutableAttributedString(string: i.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick])
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value:   NSUnderlineStyle.single.rawValue , range: NSMakeRange(0, i.name.count))
                
                selectionStyle = .none
            }
            else {
                selectionStyle = .default
            }
            
            textLabel?.attributedText = attributedString
            textLabel?.font = UIFont.init(name: "Avenir-Medium", size: 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
