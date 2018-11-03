//
//  UserModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class UserInfo: HandyJSON {
    
    static let current = UserInfo()
    
    var token : String?    //授权访问token
    var id : String?    //用户ID
    var mobile : String?    //手机号码
    var nickname : String?    //用户昵称
    var avatar : String?    //用户头像
    var points : Int? = 0    //积分
    var create_time : String?    //创建时间，格式：yyyy-MM-dd HH:mm:ss
    var bind_account3 : String?    //已绑定的第三方账号，多个账号逗号分隔
    var new_comment : Int? = 0    //有新的我的评论：大于0表示有
    var points_dlbag : Int? = 0    //每日登陆福袋 是否可领取每日登陆福袋：0 - 不可以；1 - 可以
    var points_dlbag_count : Int? = 0   //每日登陆福袋 - 奖励积分值
    var type : String?  //UserInfo的type是  "type" : "COMMON_USER",
    var web_base_url: String? 
    var app_download_url: String?
    
    func initWith(json: JSON)  {
        
        // 该方法用于更新用户信息, 但有时候 token 不会返回, 如果 token 为空, 则不更新 token
        if json["token"].stringValue.length > 1 {
            token = json["token"].stringValue
        }
        
        
        id = json["id"].stringValue
        mobile = json["mobile"].stringValue
        nickname = json["nickname"].stringValue
        avatar = json["avatar"].stringValue
        points = json["points"].intValue
        create_time = json["create_time"].stringValue
        bind_account3 = json["bind_account3"].stringValue
        new_comment = json["new_comment"].intValue
        points_dlbag = json["points_dlbag"].intValue
        points_dlbag_count = json["points_dlbag_count"].intValue
        type = json["type"].stringValue
        web_base_url = json["web_base_url"].stringValue
        app_download_url = json["app_download_url"].stringValue
    }
    
    // 退出登录的时候清空系统用户
    func removeUser() {
        token = ""
        id = ""
        mobile = ""
        nickname = ""
        avatar = ""
        points = 0
        create_time = ""
        bind_account3 = ""
        new_comment =  0
        points_dlbag =  0
        points_dlbag_count = 0
        web_base_url = ""
        app_download_url = ""
    }
    
    required init() {}
}
