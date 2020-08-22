//
//  UIView+DashedBorder.swift
//  Grocery List
//
//  Created by Rushad Antia on 8/22/20.
//  Copyright © 2020 Rushad Antia. All rights reserved.
//
import UIKit

extension UIView {
    func addDashedBorder(color: UIColor){
       
        let shapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 14).cgPath
        
        self.layer.masksToBounds = false
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeDashedBorder(){
      let _ =  self.layer.sublayers?.filter({$0.name == "DashBorder"}).map({$0.removeFromSuperlayer()})
    }
}
