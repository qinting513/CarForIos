//
//  CommonRequest.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON

extension RequestManager {
    
    func favoriteArticleRequest(articleId: String, commintId: String?=nil, isLike: Bool, finishedBlock: @escaping (_ requestStatus : Bool) -> ()) {
        
        let params: [String : Any] = [
            "op": isLike ? 1 : 0,
            "article_id": articleId,
            "comment_id": commintId ?? ""
        ]
        
        Post(URLString: URL_ArticleFav, parameters: params) {(resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                finishedBlock(true)
            } else {
                finishedBlock(false)
            }
        }
    }
    
    func likeArticleRequest(articleId: String, commintId: String?=nil, isLike: Bool, finishedBlock: @escaping (_ requestStatus : Bool) -> ()) {
        
        let params: [String : Any] = [
            "op": isLike ? 1 : 0,
            "article_id": articleId,
            "comment_id": commintId ?? ""
        ]
        
        Post(URLString: URL_ArticleLike, parameters: params) {(resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                finishedBlock(true)
            } else {
                finishedBlock(false)
            }
        }
    }
    
    func articleDetailRequest(articleID: String, finishedBlock: @escaping (_ vc : UIViewController ) -> ()) {
        let params = [
            "article_id": articleID,
            ]
        RequestManager.shared.Post(URLString: URL_ArticleDetail, parameters: params) { (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let content = result["rsp_content"].dictionaryObject
                if let article = ActicleModel.deserialize(from: toJSONString(dict: content)) {
                    let detailVC = DetailViewController()
                    detailVC.article = article
                    finishedBlock(detailVC)
                }
            }
        }
    }
    
}
