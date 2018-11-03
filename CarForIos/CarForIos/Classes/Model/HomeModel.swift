//
//  HomeModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class HomeModel: HandyJSON {
    
    var id: String?
    var title: String?
    var content: String?
    var module: String?
    var visit_count: Int = 0
    var summary: String?
    var like_count: Int = 0
    var classify: String?
    var fav_count: Int = 0
    var user_avatar: String?
    var push_app: Int = 0
    var image_url: String?
    var user_id: String?
    var user_name: String?
    var push_web: Int = 0
    var create_time: String?
    var status: Int = 0 // 状态：0: 该状态不存在,预留的字段而已  10 - 预发布；20 - 已发布
    var like: Int = 0  // 是否已点赞（登录状态下，我是否已点赞）：0 - 未点赞；1 - 已点赞
    var fav: Int = 0    //是否已收藏（登录状态下，我是否已收藏）：0 - 未收藏；1 - 已收藏
    var push_app_type: Push_App_Type? = .rightImg // LEFT_IMAGE    左侧图(APP端) RIGHT_IMAGE    右侧图(APP端) BIG_IMAGE    大图(APP端) GROUP    文章组(APP端)
    var push_app_title: String?
    var articles: [HomeModel?] = []
    
    /// UI 提的需求, 不同模块第一条线要去掉
    var showLine: Bool = true
    
    /// 是否需要隐藏大图的顶部线条
    var hidenBigImgTopLine: Bool = false
    
    required init() {}
}
