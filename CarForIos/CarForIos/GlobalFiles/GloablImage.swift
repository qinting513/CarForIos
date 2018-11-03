//
//  GloablImage.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/20.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /* 导航栏颜色 */
    public class var defaultHeader: UIImage {
        get {
            return UIImage(named: "DefaultHeader")!
        }
    }
    
    public class var defaultNoData: UIImage {
        get {
            return UIImage(named: "DefaultNoData")!
        }
    }
}
