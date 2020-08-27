//
//  ItemCell.swift
//  Grocery List
//
//  Created by Rushad Antia on 7/9/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Lightbox
import UIKit

class ItemCell: UITableViewCell {
    var item: Item?
    var store: Store?
    var starButton: UIButton?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        starButton = UIButton(type: .system)
        starButton!.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        starButton!.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        accessoryView = starButton

        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.clear.cgColor // UIColor.black.cgColor

        // cell color
        contentView.backgroundColor = #colorLiteral(red: 0.1215499714, green: 0.1215790883, blue: 0.1215502545, alpha: 1)
        contentView.layer.cornerRadius = 20

        backgroundColor = .clear
        starButton!.tintColor = .lightGray

        separatorInset = .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var cView = contentView.frame
        cView = cView.insetBy(dx: 5, dy: 0)

        contentView.frame = cView
        contentView.frame.size.width += (accessoryView?.frame.size.width)! - 10
        contentView.frame.size.height -= 2

        imageView?.frame.size.height -= 2
        imageView?.frame = (imageView?.frame.insetBy(dx: 0, dy: 4))!
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc private func handleFav() {
        if let i = item {
            if let s = store {
                i.isFavorite.toggle()
                s.save()
                setFavorite()
            }
        }
    }

    func setFavorite() {
        if let i = item {
            starButton!.tintColor = i.isFavorite ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) : UIColor.lightGray
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

    @objc func longPress() {
        if let i = item {
            if i.hasImage {
                let images = [LightboxImage(image: i.getImage()!)]

                let controller = LightboxController(images: images)

                controller.dynamicBackground = true
                controller.modalPresentationStyle = .fullScreen

                window?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }

    func setItemTitle() {
        if let i = item {
            var attributedString = NSMutableAttributedString(string: i.name)

            // if the item is marked as done then make the string strikedthrough
            if i.isDone {
                attributedString = NSMutableAttributedString(string: i.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick])
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, i.name.count))
            }
            selectionStyle = .none
            textLabel?.attributedText = attributedString
            textLabel?.textColor = .white
            textLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        }
    }
}
