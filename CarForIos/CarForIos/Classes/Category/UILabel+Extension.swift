//
//  UILabel+Extension.swift
//  WeiBo
//
//  Created by chilunyc on 16/9/7.
//  Copyright © 2016年 chilunyc. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init?(withText:String, fontSize:CGFloat, color:UIColor,numberOfLines:Int? = 0) {
        self.init()
        self.text = withText
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = color
//        self.sizeToFit()
//        self.textAlignment = .center
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = numberOfLines!
    }
    
  
  
}
