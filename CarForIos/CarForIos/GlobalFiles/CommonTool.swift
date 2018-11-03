//
//  CommonTool.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/11.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

var kScreenWidth  : CGFloat = {
    if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
        return UIScreen.main.bounds.size.height
    } else {
        return UIScreen.main.bounds.size.width
    }
}()

var kScreenHeight : CGFloat = {
    if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
        return UIScreen.main.bounds.size.width
    } else {
        return UIScreen.main.bounds.size.height
    }
}()

//MARK: - Public Method
func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return RGBA(r: r, g: g, b: b, a: 1.0)
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func randomColor() -> UIColor {
    //             red  = CGFloat0 / CGFloat 1  2个CGFloat数值比较
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    return UIColor.init(red:red, green:green, blue:blue , alpha: 1)
}

/// 颜色 生成图片
func getImageWithColor(color:UIColor)->UIImage{
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func getTextHeigh(textStr:String,font:CGFloat,width:CGFloat) -> CGFloat {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: width, height: 1000)
    let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font)], context: nil).size
    return stringSize.height
}

func getTexWidth(textStr:String,font:CGFloat,height:CGFloat) -> CGFloat {
    let normalText: NSString = textStr as NSString
    let size = CGSize(width: 1000, height: height)
    let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font)], context: nil).size
    return stringSize.width
}

// MARK: - 字典转 JSON 字符串 -
func toJSONString(dict: [String: Any]? = nil)->String{

    if dict == nil {
        return ""
    }

    let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.prettyPrinted)

    let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

    return strJson! as String

}

func toJSONString(dict: [String: Any]) -> String {
    if (!JSONSerialization.isValidJSONObject(dict)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : Data! = try! JSONSerialization.data(withJSONObject: dict, options: []) as Data?
    let JSONString = NSString(data:data ,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String

}

func toJSONString(arr: [Any]) -> String {
    if (!JSONSerialization.isValidJSONObject(arr)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : Data! = try! JSONSerialization.data(withJSONObject: arr, options: []) as Data?
    let JSONString = NSString(data:data ,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
}




// MARK: - 判断手机号码 -
func isPhoneNumber(_ phoneNumber:String) -> Bool {
    if phoneNumber.count == 0 {
        return false
    }
    // 带有新号码段的 正则, 包含电信 199
    let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|6[6]|8[0-9]|9[89]|7[0678])\\d{8}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: phoneNumber) == true {
        return true
    }
    else {
        return false
    }
}

// 判断输入的字符串是否为数字，不含其它字符
func isPurnInt(_ string: String) -> Bool {
    if string.count == 0 {
        return false
    }
    let scan: Scanner = Scanner(string: string)

    var val:Int = 0
    return scan.scanInt(&val) && scan.isAtEnd
}


func htmlString(_ string: String) -> String {
    return string.html2String
}


extension String {

    var htmlString: String {
        return html2String
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
