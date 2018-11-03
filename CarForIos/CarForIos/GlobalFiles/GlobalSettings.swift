//
//  GlobalSettings.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/1.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

/// 知 解 子标题高度
let  kSegmentBarHeight : CGFloat = 40

/// iPhoneX 有刘海
var kNavBarHeight : CGFloat = {
    if UIScreen.main.bounds.height == 812 {
        /// iPhoneX
        return 64 + 24
    }
    return 64
}()

/// 所有图标宽高比例: 600 : 320 = 1.875
let kImageScale: CGFloat = 1.875

/// 所有小图片站屏幕比例: 0.46
let kSmallImgWidthScale: CGFloat = 0.40

/// 所有小图标的宽高
let kSmallImgWidth: CGFloat = kScreenWidth * kSmallImgWidthScale
let kSmallImgHeight: CGFloat = kScreenWidth * kSmallImgWidthScale / 1.5

/// 轮播图高度
let kAdScrollViewHeight:CGFloat = kScreenWidth / kImageScale

/// TopImageBottomContentCell 的图片高度
let kTopImageHeight : CGFloat = kScreenWidth / kImageScale

/// 边距
let kMargin : CGFloat = 10
let kMarginLeft : CGFloat = 15
let kMarginRight : CGFloat = -15
let kMarginTop : CGFloat = 10
let kMarginBottm : CGFloat = -10
/// 点赞 爱心 按钮的 宽度
let kFavoriteBtnWidth :CGFloat = 70
/// 点赞 爱心 按钮的 高度
let kFavoriteBtnHeight :CGFloat = 10
let kFavoriteBtnFont : CGFloat = 11
