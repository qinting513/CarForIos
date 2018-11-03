//
//  UIViewController+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/5.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import EZSwiftExtensions

enum LDShareType {
    case Session, Timeline, Favorite/*会话, 朋友圈, 收藏*/
}


extension UIViewController {

    // 根据 articelid 跳转到详情页
    func pushDetail(with homeModel: HomeModel?) {
        if let modeId = homeModel?.id {
            pushDetail(with: modeId)
        }
    }
    
    // 根据 articelid 跳转到详情页
    func pushDetail(with articleID: String?) {
        
        showLoading()
        
        let params = [
            "article_id": articleID ?? "",
        ] as [String: Any]
        RequestManager.shared.Post(URLString: URL_ArticleDetail, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let content = result["rsp_content"].dictionaryObject
                if let article = ActicleModel.deserialize(from: toJSONString(dict: content)) {
                    let detailVC = DetailViewController()
                    detailVC.article = article
                    self?.pushVC(detailVC)
                    self?.hidenLoading()
                }
            }
        }
    }
    
    
    
    func requestDetail(with articleId: String?, finishedCallback :  @escaping (_ result : Any) -> ()) {
        showLoading()
        let params = [
            "article_id": articleId ?? "",
            ] as [String: Any]
        RequestManager.shared.Post(URLString: URL_ArticleDetail, parameters: params) { (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let content = result["rsp_content"].dictionaryObject
                if let article = ActicleModel.deserialize(from: toJSONString(dict: content)) {
                    finishedCallback(article)
                } else {
                    finishedCallback(false)
                }
            } else {
                finishedCallback(false)
            }
        }
    }
    
    
    
    
    // 判断是否已经等了, 并提示是否需要登录
    func isLogined() -> Bool{
        if  UserDefaults.standard.bool(forKey: Key_ISLogined) {
            return true
        }
        
        let alertController = UIAlertController(title: "温馨提示",message: "您还未登录,无法进行该操作,是否去登录？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "登录", style: .default, handler: { [weak self]
            action in
            AssistiveBtn.shared.removeFromSuperview()
            self?.present(UINavigationController(rootViewController: LoginViewController()), animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return false
    }
    
    
    // MARK: - 第三方分享 -
    func wechatShare(with text: String, to scene: LDShareType) {
        let req = SendMessageToWXReq()
        req.text = text
        req.bText = true
        
        switch scene {
        case .Session:
            req.scene = Int32(WXSceneSession.rawValue)
        case .Timeline:
            req.scene = Int32(WXSceneTimeline.rawValue)
        case .Favorite:
            req.scene = Int32(WXSceneFavorite.rawValue)
        }
        
        WXApi.send(req)
    }
    
    func wechatShare(url:String, image: UIImage, title: String, description: String, to scene: LDShareType) {
        
        let message=WXMediaMessage()
        message.title = htmlString(title).maxLength(maxLength: 50) // 标题最多13个字符串
        message.description = htmlString(description).maxLength(maxLength: 50)  // 描述最多20个字符串
        
        //生成缩略图
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        image.draw(in: CGRect(x: 0, y: 0, w: 100, h: 100))// 0, 0, 100, 100)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = UIImagePNGRepresentation(thumbImage!)
        
        // 生成网页对象
        let webpageobject = WXWebpageObject()
        webpageobject.webpageUrl = url
        message.mediaObject = webpageobject
        
        // 生成分享对象
        let req=SendMessageToWXReq()
        req.message=message
        req.bText=false
        
        switch scene {
        case .Session:
            req.scene = Int32(WXSceneSession.rawValue)
        case .Timeline:
            req.scene = Int32(WXSceneTimeline.rawValue)
        case .Favorite:
            req.scene = Int32(WXSceneFavorite.rawValue)
        }
        WXApi.send(req)
    }
    
    func weiboShare(url: String, image: UIImage?=nil, title: String?=nil, description: String?=nil) {
        let authRequest = WBAuthorizeRequest()
        // authRequest.redirectURI = "http://car.demo.chilunyc.com/"
        authRequest.redirectURI = (AppInfo.shared.web_base_url ?? "") + "/"
        authRequest.scope = "all"
        let msg = WBMessageObject()
        var msgText = htmlString(description ?? "").maxLength(maxLength: 50)  // 描述最多20个字符串
        // msg.text =
        print(msg.text)
        let webpage = WBWebpageObject()
        webpage.objectID = "identifier1"
        webpage.webpageUrl = url
        webpage.title = htmlString(title ?? "").maxLength(maxLength: 50)
        
        if let shareImage = image {
            let shareImageObj = WBImageObject()
            shareImageObj.imageData = UIImagePNGRepresentation(shareImage)
            msgText = msgText + " " + url
            msg.imageObject = shareImageObj
        }
        msg.text = msgText
        
        let request: WBSendMessageToWeiboRequest = WBSendMessageToWeiboRequest.request(withMessage: msg, authInfo: authRequest, access_token: sinaWeiboAppSecret) as! WBSendMessageToWeiboRequest
        WeiboSDK.send(request)
    }
}
