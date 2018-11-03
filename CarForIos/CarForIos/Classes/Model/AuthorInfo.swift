//
//  AuthorInfo.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/6.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class AuthorInfo: HandyJSON {
    
    var user_id: String?
    var user_name: String?
    var user_desc: String?
    var user_avatar: String?
    
    required init() {}
}
