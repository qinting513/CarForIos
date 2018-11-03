
//
//  CommentsTableViewCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    
    var iconBtn : UIButton?
    var nickNameLabel : UILabel?
    var timeLabel : UILabel?
    var commentLabel : UILabel?
    /// 点赞按钮
    var likeButton : UIButton?
    
    var comment: CommentModel? = nil {
        didSet{
            iconBtn?.setImage(with: URL(string: comment?.user_avatar ?? ""), placeHolder: UIImage(named: "DefaultHeader"))
            nickNameLabel?.text = (comment?.user_nickname?.length)! < 1 ? "春风十里不如你" : comment?.user_nickname
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// 头像
        iconBtn = UIButton(title: "", titleColor: UIColor.white, img: nil, selectedImg: nil, fontSize: 15, bgColor: .mainColor, target: self, action: #selector(iconBtnClick))
        iconBtn?.backgroundColor = UIColor.darkGray
        self.contentView.addSubview(iconBtn!)
        iconBtn?.layer.masksToBounds = true
        let iconBtnWH :CGFloat = 50
        iconBtn?.layer.cornerRadius = iconBtnWH * 0.5
        iconBtn?.snp.makeConstraints({(make) in
            make.width.height.equalTo(iconBtnWH)
            make.left.equalToSuperview().offset(kMargin*2)
            make.top.equalToSuperview().offset(kMargin*2)
        })
        
        /// 昵称
        nickNameLabel = UILabel()
        nickNameLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nickNameLabel?.text = "用户昵称卡米尔 xxx"
        nickNameLabel?.textColor = UIColor.darkGray
        self.contentView.addSubview(nickNameLabel!)
        nickNameLabel?.snp.makeConstraints({ (make) in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.left.equalTo(iconBtn?.snp.right ?? 0).offset(kMargin)
            make.top.equalTo(iconBtn?.snp.top ?? 0).offset(0)
        })
        
        timeLabel = UILabel(withText: "5小时前", fontSize: 11, color: .lightGray, numberOfLines: 1)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(iconBtn?.snp.right ?? 0).offset(kMargin)
            make.top.equalTo(nickNameLabel?.snp.bottom ?? 0).offset(0)
            make.width.equalTo(nickNameLabel?.snp.width ?? 0)
            make.height.equalTo(15)
        })
        
        likeButton = UIButton(title: "1234423", img: "feed_video_unlike", selectedImg: "feed_video_like")
        likeButton?.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
        self.addSubview(likeButton!)
        likeButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
            make.top.equalTo(nickNameLabel?.snp.top ?? 0)
            make.width.equalTo(100)
            make.height.equalTo(30)
        })
        
        commentLabel = UILabel(withText: "", fontSize: 13, color: .lightGray, numberOfLines: 0)
        self.addSubview(commentLabel!)
        commentLabel?.lineBreakMode = .byTruncatingTail
        commentLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(iconBtn?.snp.bottom ?? 0).offset(0)
            make.left.equalTo(nickNameLabel?.snp.left ?? 0).offset(0)
            make.bottom.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
        }
        commentLabel?.text = "但是我现在会看到（希望我是片面的），如果是在上海的年轻人，他出生的时候已经看到一个贫富分化的阶层，"
    }
    
    @objc func iconBtnClick(button:UIButton){
        
    }
    
    @objc func likeButtonClick(button:UIButton){
        button.isSelected = !button.isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
