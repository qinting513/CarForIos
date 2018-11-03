//
//  GlobalColor.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/11.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

func HexString(hex:String) -> UIColor {

    var cString:String = hex.trimmingCharacters(in: NSCharacterSet.newlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString = cString.substring(from: 1, length: cString.length - 1)!
    }
    
    if (cString.length != 6) {
        return .white
    }
    
    let rString = cString.substring(from: 0, length: 2)
    let gString = cString.substring(from: 2, length: 2)
    let bString = cString.substring(from: 4, length: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString!).scanHexInt32(&r)
    Scanner(string: gString!).scanHexInt32(&g)
    Scanner(string: bString!).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}


extension UIColor {
    /* 导航栏颜色 */
    public class var mainColor: UIColor {
        get {
            return RGB(r: 108, g: 156, b: 240)
            //return RGB(r: 241, g: 134, b: 51)
        }
    }
    
    /* 标题颜色 */
    public class var titleColor: UIColor {
        get {
            return UIColor(hexString: "222222")
        }
    }
    
    /* 副标题颜色 */
    public class var subtitleColor: UIColor {
        get {
            return RGB(r: 102, g: 102, b: 102)
        }
    }
    
    /* 公共背景色 */
    public class var backgroundColor: UIColor {
        get {
            return RGB(r: 250, g: 250, b: 250)
        }
    }
    
    /* banner 下面指示器颜色 */
    public class var MainColorBannerLine: UIColor {
        get {
            return RGB(r: 235, g: 165, b: 58)
        }
    }
    
    /** 公共线条颜色 */
    public class var lineColor: UIColor {
        get {
            return RGB(r: 215, g: 215, b: 215)
        }
    }
    
    public class var goldenYellowColor: UIColor {
        get {
            return RGB(r: 254, g: 242, b: 109)
        }
    }
}
