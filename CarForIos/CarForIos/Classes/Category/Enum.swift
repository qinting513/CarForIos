//
//  Enum.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/19.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

enum Push_App_Type: String, HandyJSONEnum {
    case leftImg  = "LEFT_IMAGE"
    case rightImg = "RIGHT_IMAGE"
    case bigImg   = "BIG_IMAGE"
    case group    = "GROUP"
}

// 第三方类型
enum ThirdType {
    case weibo, wechat
}

// 内容板块
enum Module_Type: String, HandyJSONEnum {
    case home  = "HOME"
    case play_car = "PLAY_CAR"
    case toy   = "TOY"
}

// 文章分类
enum Classify_Type: String, HandyJSONEnum {
    case know  = "KNOW"
    case solve = "SOLVE"
}



// Banner 跳转类型
enum Banner_Type: String, HandyJSONEnum {
    case no  = "NO"
    case link = "LINK"
    case article = "ARTICLE"
}

enum Img_Tag_Type:String, HandyJSONEnum {
    case description = "DESC"
    case link = "LINK"
    case image = "IMG"
}
