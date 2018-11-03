//
//  ThirdLoginManager.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/1.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

enum ThirdType {
    case weibo, wechat
}

typealias ThirdLoginfinishedBlock = (_ code: String) -> Void

class ThirdLoginManager: NSObject {
    static let shared = ThirdLoginManager()
    
    var mFinishedBlock: ThirdLoginfinishedBlock?
    
    func weiboLogin(finishedBlock: @escaping (_ requestStatus : Bool) -> ()) {
        let request = WBAuthorizeRequest()
        request.scope = "all"
        // 此字段的内容可自定义, 在请求成功后会原样返回, 可用于校验或者区分登录来源
        // request.userInfo = ["": ""]
        request.redirectURI = "https://weibo.com"
        
        WeiboSDK.send(request)
    }
    
    func weixinLogin(finishedBlock: @escaping (_ code : String) -> ()) {
        if WXApi.isWXAppInstalled() {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "App"
            WXApi.send(req)
            mFinishedBlock = finishedBlock
        }
    }
}




extension AppDelegate {
    
}
