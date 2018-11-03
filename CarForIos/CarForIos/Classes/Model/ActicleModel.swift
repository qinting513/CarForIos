//
//  ActicleModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/20.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class ActicleModel: HandyJSON {

    var id: String? // id
    var title: String? // 标题
    var content: String? // 内容
    var summary: String? // 摘要
    var module: Module_Type? // 板块
    var classify: String? // 分类
    var image_url: String? // 配图
    var user_id: String? // 作者ID
    var user_name: String? // 作者姓名
    var user_avatar: String? // 作者头像
    var visit_count: Int = 0   //  浏览量
    var like_count: Int = 0   //  总的点赞数
    var fav_count: Int = 0   //  总的收藏数
    var push_web: Int = 0   //  Web手推：0 - 未推；1 - 已推
    var push_web_type: String? // 推送类型
    var push_app: Int = 0   //  App手推：0 - 未推；1 - 已推
    var push_app_type: Int = 0   //  推送类型
    var create_time: String? // 创建时间，格式：yyyy-MM-dd HH:mm:ss
    var status: Int = 0   //  状态：10 - 预发布；20 - 已发布
    var like: Int = 0   //  是否已点赞（登录状态下，我是否已点赞）：0 - 未点赞；1 - 已点赞
    var fav: Int = 0   //  是否已收藏（登录状态下，我是否已收藏）：0 - 未收藏；1 - 已收藏
    var content_base_url: String?
    
    required init() {}
}
