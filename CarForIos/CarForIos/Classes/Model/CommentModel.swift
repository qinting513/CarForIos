//
//  CommentModel.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON

class CommentModel: HandyJSON {
    var id: String?  // 评论ID
    var user_id: String?  //     评论用户ID
    var user_nickname: String?  //     评论用户昵称
    var user_avatar: String?  //     评论用户头像
    var content: String?  //     评论内容
    var like_count: Int = 0  //     总的点赞数
    var create_time: String?  //     评论时间，格式：yyyy-MM-dd HH:mm:ss
    var like: Int = 0  //  是否已点赞（登录状态下，我是否已点赞）：0 - 未点赞；1 - 已点赞
    var src_comment: CommentModel? //     原评论对象，如果是对评论进行评论，则有该对象
    var article: HomeModel?
    
    
    // cell的高度
    // 注意评论的文字大小是13 如果有src_comment 则src_comment的评论的文字大小为12
    var cellHeight : CGFloat {
        get {
            
            if src_comment != nil {
                return 75 + commentLabelHeight + 80 + mOriginalCommentContentHeight
            }
            
            else {
                return 75 + commentLabelHeight
            }
        }
    }
    
    var commentLabelHeight : CGFloat {
        get {
            return getTextHeigh(textStr: self.content ?? "", font: 13, width: kScreenWidth - 50 - kMarginLeft - kMarginLeft - -kMarginRight) + 10
        }
    }
    
    
    // 原来评论内容高度
    var mOriginalCommentContentHeight: CGFloat {
        get {
            return getTextHeigh(textStr: src_comment?.content ?? "", font: 12, width: kScreenWidth - 30 - 40) + 20
        }
    }
    
    // 用于我的通知列表
    var mNoticeCellHeight: CGFloat {
        get {
            // 10 + 20 +10 + 20 + 10 + 000 + 10 + 000 + 10 + 000 + 20 + kSmallImgHeight + kMarginTop + -kMarginBottm +
            // 130 + kSmallImgHeight + mOriginalCommentContentHeight + commentLabelHeight
            return 190 + commentLabelHeight + mOriginalCommentContentHeight + kSmallImgHeight
        }
    }
    
    required init() {}
}
