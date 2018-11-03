//
//  BannerModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/19.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class BannerModel: HandyJSON {
    
    var module: Module_Type?
    var id: String?
    var classify: Classify_Type?
    var title: String?
    var image_url: String?
    var type: Banner_Type?
    var create_time: String?
    var url: String?
    var article_id: String?
    
    required init() {}
}
