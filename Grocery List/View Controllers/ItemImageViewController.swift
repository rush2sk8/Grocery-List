//
//  ItemImageViewController.swift
//  Grocery List
//
//  Created by Rushad Antia on 6/29/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//

import Foundation
import UIKit

class ItemImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var item: Item?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let itm = self.item {
            if itm.hasImage {
                let newImageData = Data(base64Encoded: itm.imageString!)
                if let img = newImageData {
                    imageView.image = UIImage(data: img)
                }
            }
        }
    }
}
