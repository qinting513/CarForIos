//
//  MyFavModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/2.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class MyFavModel: HandyJSON {

    var total : Int = 0
    var page_index : Int = 0
    var page_size : Int = 0
    var items : [MyFavItemModel]? = []
    required init() {}
}
class MyFavItemModel: HandyJSON {
    /// 收藏时间
      var fav_time : String?
    /// 收藏的article
      var article: HomeModel?
       required init() {}
}
