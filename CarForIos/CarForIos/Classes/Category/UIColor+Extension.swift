//
//  UIColor+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/23.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
enum GradientChangeDirection {
    case level, vertical, upwardDiagonalLine, downDiagonalLine
}

extension UIColor {
    class func colorGradientChange(with size: CGSize, direction: GradientChangeDirection, startColor: UIColor, endColor: UIColor) -> UIColor{
        if size.equalTo(.zero) {
            return .clear
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, w: size.width, h: size.height)
        
        var startPoint:CGPoint = .zero
        if (direction == .downDiagonalLine) {
            startPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradientLayer.startPoint = startPoint
        
        var endPoint:CGPoint = .zero
        
        switch (direction) {
        case .level:
            endPoint = CGPoint(x: 1.0, y: 0.0)
            break;
        case .vertical:
            endPoint = CGPoint(x: 0.0, y: 1.0)
            break;
        case .upwardDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 1.0)
            break;
        case .downDiagonalLine:
            endPoint = CGPoint(x: 1.0, y: 0.0)
            break;
        }
        gradientLayer.endPoint = endPoint;
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        UIGraphicsBeginImageContext(size);
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIColor(patternImage: image!)
        }
}
