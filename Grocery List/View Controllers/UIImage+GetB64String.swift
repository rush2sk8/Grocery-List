//
//  UIImage+GetB64String.swift
//  Grocery List
//
//  Created by Rushad Antia on 9/25/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//


import UIKit

extension UIImage {
    
    func getB64String(_ compressionQuality: CGFloat = 0.3) -> String? {
        let imageData = self.jpegData(compressionQuality: compressionQuality)
        return imageData?.base64EncodedString()
    }
    
}
