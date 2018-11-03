//
//  UIImageView+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/19.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with url: Resource?) {
        setImage(with: url, placeHolder: Image(named: "DefaultNoData"))
    }
    
    func setImage(with url: Resource?, completionHandler: CompletionHandler? = nil) {
        setImage(with: url, placeHolder: nil, completionHandler: completionHandler)
    }
    
    func setImage(with url: Resource?, placeHolder: Image?=nil) {
        kf.setImage(with: url, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    func setImage(with url: Resource? , placeHolder: Image?=nil, completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: url, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: completionHandler)
    }
}


extension UIImage {
    
    //将图片缩放成指定尺寸（多余部分自动删除）
    func scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
//
//extension UIImage{
//    /**
//     设置是否是圆角(默认:3.0,图片大小)
//     */
//    func isRoundCorner() -> UIImage{
//        return self.isRoundCorner(radius: 3.0, size: self.size)
//    }
//    /**
//     设置是否是圆角
//     - parameter radius: 圆角大小
//     - parameter size:   size
//     - returns: 圆角图片
//     */
//    func isRoundCorner(radius:CGFloat,size:CGSize) -> UIImage {
//        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
//        //开始图形上下文
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        //绘制路线
//        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect,
//                                                            byRoundingCorners: UIRectCorner.allCorners,
//                                                            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
//        //裁剪
//        UIGraphicsGetCurrentContext()?.clip()
//        //将原图片画到图形上下文
//        self.draw(in: rect)
//        CGContext.drawPath(UIGraphicsGetCurrentContext()!)
//        CGContextDrawPath(UIGraphicsGetCurrentContext()!, .fillStroke)
//        let output = UIGraphicsGetImageFromCurrentImageContext();
//        //关闭上下文
//        UIGraphicsEndImageContext();
//        return output!
//    }
//    /**
//     设置圆形图片
//     - returns: 圆形图片
//     */
//    func isCircleImage() -> UIImage {
//        //开始图形上下文
//        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
//        //获取图形上下文
//        let contentRef:CGContext = UIGraphicsGetCurrentContext()!
//        //设置圆形
//        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
//        //根据 rect 创建一个椭圆
//        CGContextAddEllipseInRect(contentRef, rect)
//        //裁剪
//        CGContextClip(contentRef)
//        //将原图片画到图形上下文
//        self.drawInRect(rect)
//        //从上下文获取裁剪后的图片
//        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        //关闭上下文
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//}
