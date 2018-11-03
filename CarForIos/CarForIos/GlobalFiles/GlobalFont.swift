//
//  GlobalFont.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

extension UIFont {
   
    /* 文章详情 标题 特大号字体 */
    public class var articleTitleFont: UIFont {
        get {
            if #available(iOS 8.2, *) {
                return UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 2))
            } else {
                // Fallback on earlier versions
                return UIFont.systemFont(ofSize: 18)
            }
        }
    }
    
    /* 标题字体 */
    public class var titleFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 16)
        }
    }
    
    /* 副标题字体 */
    public class var subtitleFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 14)
        }
    }
    
    /* 比较少用字体, 不大不小的就是这个了 */
    public class var otherFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 13)
        }
    }
    
    /* 最小字体 */
    public class var smallFont: UIFont {
        get {
            return UIFont.systemFont(ofSize: 10)
        }
    }
}
