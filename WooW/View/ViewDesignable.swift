//
//  ViewDesignable.swift
//  WooW
//
//  Created by Rahul Chopra on 28/04/21.
//

import Foundation
import UIKit

@IBDesignable class DesignableView: UIView {
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            shapeLayer.strokeColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    let shapeLayer = CAShapeLayer()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createBorder()
    }
    
    func createBorder() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: width, y: height - 5))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: 0, y: height - 5))
        
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
}
