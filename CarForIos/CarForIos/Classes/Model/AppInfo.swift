//
//  AppInfo.swift
//  CarForIos
//
//  Created by chilunyc on 2018/9/2.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class AppInfo: HandyJSON {
    
    static let shared = AppInfo()
    
    var web_base_url: String? //    Web端基地址
    var app_download_url: String? //    App下载页地址
    var launch_img_url: String? //    启动图地址
    
    required init() {
        
    }
    
    func initWith(json: JSON)  {
        web_base_url = json["web_base_url"].stringValue
        app_download_url = json["app_download_url"].stringValue
        launch_img_url = json["launch_img_url"].stringValue
    }
}
