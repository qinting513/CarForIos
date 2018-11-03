//
//  ImgTagModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/15.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class ImgTagModel: HandyJSON {
    
    var type: Img_Tag_Type?
    var description: String?
    var name: String?
    var image_url: String?
    var link: String?
    
    required init() {}
}
