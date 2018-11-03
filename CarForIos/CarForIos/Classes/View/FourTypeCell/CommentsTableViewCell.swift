
//
//  CommentsTableViewCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SwiftRichString

// 评论字体
let commentLabelFont : CGFloat = 13.0
let srcCommentLabelFont : CGFloat = 12

class CommentsTableViewCell: UITableViewCell {


    var iconBtn : UIButton?
    var nickNameLabel : UILabel?
    var timeLabel : UILabel?
    var commentLabel : UILabel?
    /// 点赞按钮
    var likeButton : UIButton?

    var mDelegate: CommentsTableViewCellDelegte?
    var mIndexPath: IndexPath?

    var mRcommonView: UIView?
    var mRcommonIconBtn: UIButton?
    var mRcommonNickName: UILabel?
    var mRcommonContent: UILabel?
    var mBottomLine: UIView?

    var comment: CommentModel? = nil {
        didSet{

            if let userAvatar = comment?.user_avatar {
                iconBtn?.setBackgroundImageWith(URL(string: userAvatar), for: .normal, placeholder: nil)
            } else {
                iconBtn?.setBackgroundImage(.defaultHeader, for: .normal)
            }

            if (comment?.user_nickname?.trimmed().length ?? 0) > 1  {
                 nickNameLabel?.text = comment?.user_nickname  ?? "匿名用户"
            }else{
                 nickNameLabel?.text = "匿名用户"
            }

            timeLabel?.text = comment?.create_time?.toAgoString()
            likeButton?.isSelected = comment?.like == 1
            likeButton?.setTitle(comment?.like_count.toString, for: .normal)
            commentLabel?.text = comment?.content ?? ""


            if comment?.src_comment != nil {
                let replyComment: CommentModel = (comment?.src_comment!)!
                mRcommonView?.isHidden = false
                if let rUserAvatar = comment?.src_comment?.user_avatar {
                    print("rUserAvatar: \(rUserAvatar)")
                    mRcommonIconBtn?.setBackgroundImageWith(URL(string: rUserAvatar), for: .normal, placeholder: nil)
                } else {
                    mRcommonIconBtn?.setBackgroundImage(.defaultHeader, for: .normal)
                }
                mRcommonNickName?.text = replyComment.user_nickname ?? "匿名用户"
                mRcommonContent?.text = replyComment.content ?? ""
            } else {
                mRcommonView?.isHidden = true
            }

            commentLabel?.snp.updateConstraints({ (make) in
                make.height.equalTo(comment?.commentLabelHeight ?? 0)
            })

            if comment?.src_comment != nil {
                mRcommonView?.snp.updateConstraints({ (make) in
                    make.height.equalTo((comment?.mOriginalCommentContentHeight ?? 0) + 20 + 50)
                })
                mRcommonContent?.snp.updateConstraints({ (make) in
                    make.height.equalTo((comment?.mOriginalCommentContentHeight ?? 0) + 20)
                })
            }
        }
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        /// 头像
        let avatorBtn = UIButton()
        iconBtn = avatorBtn
        avatorBtn.addTarget(self, action: #selector(iconBtnClick), for: .touchUpInside)
        avatorBtn.backgroundColor = .white
        contentView.addSubview(avatorBtn)
        avatorBtn.setBackgroundImage(.defaultHeader, for: .normal)
        avatorBtn.layer.masksToBounds = true
        let iconBtnWH :CGFloat = 50
        avatorBtn.layer.cornerRadius = iconBtnWH * 0.5
        avatorBtn.snp.makeConstraints({(make) in
            make.width.height.equalTo(iconBtnWH)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalToSuperview().offset(15)
        })

        /// 昵称
        nickNameLabel = UILabel()
        nickNameLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nickNameLabel?.text = "用户昵称卡米尔 xxx"
        nickNameLabel?.textColor = HexString(hex: "222222")
        contentView.addSubview(nickNameLabel!)
        nickNameLabel?.snp.makeConstraints({ (make) in
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(30)
            make.left.equalTo(iconBtn?.snp.right ?? 0).offset(kMarginLeft)
            make.top.equalTo(iconBtn?.snp.top ?? 0).offset(0)
        })


        timeLabel = UILabel(withText: "5小时前", fontSize: 11, color: .lightGray, numberOfLines: 1)
        contentView.addSubview(timeLabel!)
        timeLabel?.textColor = HexString(hex: "999999")
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(nickNameLabel?.snp.left ?? 0)
            make.top.equalTo(nickNameLabel?.snp.bottom ?? 0).offset(0)
            make.width.equalTo(nickNameLabel?.snp.width ?? 0)
            make.height.equalTo(15)
        })


        likeButton = UIButton(title: "", img: "feed_video_unlike", selectedImg: "feed_video_like")
        likeButton?.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
        likeButton?.forbidInterval = 2
        likeButton?.setTitleColor(HexString(hex: "999999"), for: .normal)
//        likeButton?.imageEdgeInsets = UIEdgeInsets(top: 9, left: -5, bottom: 14, right: 10)
        likeButton?.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 15)
        contentView.addSubview(likeButton!)
        likeButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(nickNameLabel?.snp.top ?? 0)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(10)
        })


        commentLabel = UILabel(withText: "", fontSize: commentLabelFont, color: .lightGray, numberOfLines: 0)
        contentView.addSubview(commentLabel!)
        commentLabel?.numberOfLines = 0
        commentLabel?.lineBreakMode = .byTruncatingTail
        commentLabel?.textColor = HexString(hex: "666666")
        commentLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(iconBtn?.snp.bottom ?? 0).offset(0)
            make.left.equalTo(nickNameLabel?.snp.left ?? 0).offset(0)
            make.right.equalToSuperview().offset(kMarginRight)
            make.height.equalTo((comment?.commentLabelHeight ?? 20))
        }

        mBottomLine = UIView()
        mBottomLine?.backgroundColor = .lineColor
        contentView.addSubview(mBottomLine!)
        mBottomLine?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(commentLabel!)
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
        })

        mRcommonView = UIView()
        contentView.addSubview(mRcommonView!)
        mRcommonView?.backgroundColor = .backgroundColor



        mRcommonIconBtn = UIButton(title: "", titleColor: .white, img: nil, selectedImg: nil, fontSize: 15, bgColor: .mainColor, target: nil, action: nil)
        mRcommonIconBtn?.setBackgroundImage(.defaultHeader, for: .normal)
        mRcommonView?.addSubview(mRcommonIconBtn!)
        mRcommonIconBtn?.layer.masksToBounds = true
        mRcommonIconBtn?.layer.cornerRadius = 20

        /// 昵称
        mRcommonNickName = UILabel()
        mRcommonNickName?.font = UIFont.boldSystemFont(ofSize: 13)
        mRcommonNickName?.text = "用户昵称"
        mRcommonNickName?.textColor = HexString(hex: "666666")
        mRcommonView?.addSubview(mRcommonNickName!)

        mRcommonContent = UILabel(withText: "", fontSize: srcCommentLabelFont, color: HexString(hex: "999999"), numberOfLines: 0)
        mRcommonView?.addSubview(mRcommonContent!)
        mRcommonContent?.lineBreakMode = .byTruncatingTail

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if comment?.src_comment != nil {
            mRcommonView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(commentLabel!)
                make.top.equalTo(commentLabel?.snp.bottom ?? 0).offset(kMarginTop)
                make.height.greaterThanOrEqualTo(90)
            })



            mRcommonIconBtn?.snp.makeConstraints({ (make) in
                make.left.equalTo(mRcommonView?.snp.left ?? 0).offset(5)
                make.top.equalTo(mRcommonView?.snp.top ?? 0).offset(kMarginTop)
                make.width.height.equalTo(40)
            })

            mRcommonNickName?.snp.makeConstraints({ (make) in
                make.left.equalTo(mRcommonIconBtn?.snp.right ?? 0).offset(kMarginLeft)
                make.top.equalTo(mRcommonIconBtn?.snp.top ?? 0)
                make.height.equalTo(30)
                make.right.equalTo(mRcommonView?.snp.right ?? 0)
            })

            mRcommonContent?.snp.makeConstraints({ (make) in
                make.left.equalTo(mRcommonIconBtn?.snp.right ?? 0).offset(kMarginLeft)
                make.right.equalTo(mRcommonView?.snp.right ?? 0)
                make.top.equalTo(mRcommonNickName?.snp.bottom ?? 0).offset(kMarginTop)
                make.height.greaterThanOrEqualTo(30)
            })
        }
    }



    @objc func iconBtnClick(button:UIButton){
         self.mDelegate?.commentsCellHeaderBtnClick(indexPathRow: mIndexPath?.row ?? 0, isKnow: true, comment: comment, sender: button)
    }

    @objc func likeButtonClick(button:UIButton){
        self.mDelegate?.commentsCellLikeBtnClick(indexPathRow: mIndexPath?.row ?? 0, isKnow: true, comment: comment, sender: button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CommentsTableViewCellDelegte {
    /// 点赞按钮点击
    func commentsCellLikeBtnClick(indexPathRow : Int, isKnow:Bool?, comment: CommentModel?, sender: UIButton)
    /// 头像点击事件
    func commentsCellHeaderBtnClick(indexPathRow : Int, isKnow:Bool?, comment: CommentModel?, sender: UIButton)

}
