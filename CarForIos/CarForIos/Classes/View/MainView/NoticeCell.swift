//
//  NoticeCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class NoticeCell: UITableViewCell{
    
    var mComment: CommentModel? {
        didSet{
            
            setupReplyCommentLabel(comment: mComment)
            replyTimeLabel?.text = (mComment?.create_time ?? "").toAgoString()
            replyContentLabel?.text = mComment?.content ?? ""
            originAvatarImageView?.setImage(with: URL(string: mComment?.src_comment?.user_avatar ?? ""), placeHolder: .defaultHeader)
            originAuthorNameLabel?.text = mComment?.src_comment?.user_nickname ?? "匿名用户"
            originContentLabel?.text = mComment?.src_comment?.content ?? ""
            articleCell?.setupModel(model: mComment?.article, indexPathRow: 0, isKnow: false)
            
            originBgView?.snp.updateConstraints({ (make) in
                make.height.equalTo(60 + (mComment?.mOriginalCommentContentHeight)!)
            })
        }
    }
    
    
    /// 评论视图
    var mCommonBGView: UIView?
    /// ABC 回复了你的评论
    var replyCommentLabel : UILabel?
    /// 回复时间
    var replyTimeLabel : UILabel?
    /// 回复内容
    var  replyContentLabel : UILabel?
    
    var originBgView : UIView?
    ///原帖的图片
    var originAvatarImageView : UIImageView?
    /// 作者名字
    var originAuthorNameLabel : UILabel?
    /// 原贴内容
    var originContentLabel : UILabel?
    /// 分割线
    var seperatorLineView : UIView?
    /// 回复按钮
    var mReplayBtn: UIButton?
    
    /// 原帖的cell所占的view
    var articleAreaView : UIView?
    var articleCell : LContentRImageCell?
    
    var bottomSeperatorView : UIView?
    
    var mDelegate: NoticeCellDidSelectedDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        replyTimeLabel = UILabel()
        replyTimeLabel?.textAlignment = .left
        replyTimeLabel?.textColor = RGB(r: 93, g: 153, b: 246)
        replyTimeLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 12)
        contentView.addSubview(replyTimeLabel!)
        replyTimeLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalToSuperview().offset(kMarginTop)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(40)
        })
        
        replyCommentLabel = UILabel()
        contentView.addSubview(replyCommentLabel!)
        replyCommentLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalTo(replyTimeLabel?.snp.bottom ?? 0).offset(kMarginTop)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-115)
        })
        
        mReplayBtn = UIButton()
        mReplayBtn?.setTitle("回复", for: .normal)
        mReplayBtn?.setBackgroundColor(.clear, forState: .normal)
        mReplayBtn?.setTitleColor(.mainColor, for: .normal)
        mReplayBtn?.layer.masksToBounds = true
        mReplayBtn?.addTarget(self, action: #selector(replyBtnAction), for: .touchUpInside)
        mReplayBtn?.layer.cornerRadius = 5
        mReplayBtn?.layer.borderWidth = 1
        mReplayBtn?.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 12)
        mReplayBtn?.layer.borderColor = UIColor.mainColor.cgColor
        contentView.addSubview(mReplayBtn!)
        mReplayBtn?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.centerY.equalTo(replyCommentLabel!)
            make.width.equalTo(40)
            make.height.equalTo(20)
            
        })
        
        replyContentLabel = UILabel()
        replyContentLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 12)
        replyContentLabel?.numberOfLines = 0
        replyContentLabel?.textColor = RGB(r: 102, g: 102, b: 102)
        contentView.addSubview(replyContentLabel!)
        replyContentLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(replyCommentLabel?.snp.left ?? 0)
            make.top.equalTo(replyCommentLabel?.snp.bottom ?? 0).offset(kMarginTop)
            make.right.equalToSuperview().offset(kMarginRight)
        })
        
        originBgView = UIView()
        originBgView?.backgroundColor = .backgroundColor
        contentView.addSubview(originBgView!)
        originBgView?.snp.makeConstraints({ (make) in
            make.left.equalTo(replyCommentLabel?.snp.left ?? 0)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(replyContentLabel?.snp.bottom ?? 0).offset(kMarginTop)
            make.height.equalTo(120)
        })
        
        originAvatarImageView = UIImageView(image: getImageWithColor(color: .lightGray))
        originBgView?.addSubview(originAvatarImageView!)
        let avatarWH :CGFloat = 40
        originAvatarImageView?.layer.masksToBounds = true
        originAvatarImageView?.layer.cornerRadius = avatarWH * 0.5
        originAvatarImageView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(kMarginTop)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.width.height.equalTo(avatarWH)
        })
        
        originAuthorNameLabel = UILabel()
        originBgView?.addSubview(originAuthorNameLabel!)
        originAuthorNameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(originAvatarImageView?.snp.right ?? 0).offset(kMargin)
            make.right.equalTo(originBgView?.snp.right ?? 0).offset(-kMargin)
            make.centerY.equalTo(originAvatarImageView?.snp.centerY ?? 0)
        })
        
        originContentLabel = UILabel()
        originContentLabel?.numberOfLines = 0
        originContentLabel?.textColor = RGB(r: 153, g: 153, b: 153)
        originContentLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 12)
        originBgView?.addSubview(originContentLabel!)
        originContentLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(originAuthorNameLabel?.snp.left ?? 0)
            make.right.equalToSuperview()
            make.top.equalTo(originAvatarImageView?.snp.bottom ?? 0).offset(kMarginTop)
        })
        
        seperatorLineView = UIView()
        seperatorLineView?.backgroundColor = HexString(hex: "#d7d7d7")
        contentView.addSubview(seperatorLineView!)
        seperatorLineView?.snp.makeConstraints { (make) in
            make.height.equalTo(1.0)
            make.left.equalTo(replyCommentLabel?.snp.left ?? 0)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(originBgView?.snp.bottom ?? 0).offset(kMarginTop)
        }

        
        articleAreaView = UIView()
        articleAreaView?.addPanGesture(target: self, action: #selector(articleClickAction))
        articleAreaView?.backgroundColor = .backgroundColor
        contentView.addSubview(articleAreaView!)
        articleAreaView?.snp.makeConstraints({ (make) in
            make.left.equalTo(replyCommentLabel?.snp.left ?? 0)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(seperatorLineView?.snp.bottom ?? 0)
            make.height.equalTo(kSmallImgHeight + kMarginTop + -kMarginBottm)
            
        })
        
        
        let cell = LContentRImageCell(style: .default, reuseIdentifier: "")
        articleAreaView?.addSubview(cell)
        cell.topSeperatorView?.backgroundColor = .backgroundColor
        articleCell = cell
        articleCell?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
        

        bottomSeperatorView = UIView()
        bottomSeperatorView?.backgroundColor = backgroundColor
        self.addSubview(bottomSeperatorView!)
        bottomSeperatorView?.snp.makeConstraints({ (make) in
            make.height.equalTo(0.0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(articleAreaView?.snp.bottom ?? 0).offset(kMargin)
        })
    }
    
    func setupReplyCommentLabel(comment: CommentModel?) {
        var userName = comment?.user_nickname ?? ""
        userName = userName.isEmpty ? "匿名用户" : userName
        
        // swift 富文本框架:  https://github.com/malcommac/SwiftRichString
        let name = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14)
            $0.color = RGB(r: 34, g: 34, b: 34)
        }
        
        let content = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 14)
            $0.color = RGB(r: 153, g: 153, b: 153)
        }
        
        let myGroup = StyleGroup(["name": name, "content": content])
        let str = "<name>\(userName)</name><content> 回复了您的评论</content>"
        replyCommentLabel?.attributedText = str.set(style: myGroup)
    }
    
    @objc func commonDidSelected() {
        mDelegate?.NoticeCellCommonDidSelected(comment: mComment!)
    }
    
    @objc func articleClickAction() {
        mDelegate?.NoticeCellArticleDidSelected(comment: mComment!)
    }
    
    @objc func replyBtnAction() {
        mDelegate?.NoticeCellReplyBtnDidSelected(comment: mComment!)
    }
}

protocol NoticeCellDidSelectedDelegate {
    func NoticeCellCommonDidSelected(comment: CommentModel)
    
    func NoticeCellArticleDidSelected(comment: CommentModel)
    
    func NoticeCellReplyBtnDidSelected(comment: CommentModel)
}
