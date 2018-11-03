//
//  LImageRContentCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SnapKit
import SwiftRichString

class LImageRContentCell: BaseHomeCell {

   public var topSeperatorView : UIView?
    
   func setupUI() {
   
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lineColor
        self.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(1)
        }
        mLineView = seperatorView
    
        imgView = UIImageView()
            imgView?.image = getImageWithColor(color: .blue)
            self.addSubview(imgView!)
            imgView?.snp.makeConstraints({ (make) in
                make.top.equalTo(seperatorView.snp.bottom).offset(kMarginTop)
                make.bottom.equalToSuperview().offset(kMarginBottm)
                make.left.equalToSuperview().offset(kMarginLeft)
               make.width.equalTo(kSmallImgWidth)
           })
    
        imgView?.setCornerRadius(radius: 5)
    
        timeLabel = UILabel(withText: "5小时前", fontSize: kFavoriteBtnFont, color: .subtitleColor, numberOfLines: 1)
            self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-kMargin)
            make.left.equalTo(imgView?.snp.right ?? 0).offset(kMargin)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        })
    
//    favoriteBtn = UIButton(title: "1234", titleColor: .subtitleColor,
//                       img: "feed_video_unlike", selectedImg: "feed_video_like", target: self, action: #selector(favoriteBtnClick))
    favoriteBtn = UIButton(title: "678971", titleColor: .subtitleColor, img: "feed_video_unlike_new", selectedImg: "feed_video_like")
            self.addSubview(favoriteBtn!)
            favoriteBtn?.snp.makeConstraints { (make) in
              make.right.bottom.equalToSuperview().offset(-kMargin)
              make.width.equalTo(kFavoriteBtnWidth)
              make.height.equalTo(kFavoriteBtnHeight)
            }
    
//    likeBtn = UIButton(title: "274", titleColor: .subtitleColor,
//                          img: "feed_video_unlike", selectedImg: "feed_video_like", target: self, action: #selector(likeBtnClick))
//    likeBtn?.addTarget(self, action: #selector(likeBtnClick), for: .touchUpInside)
    likeBtn = UIButton(title: "678971", titleColor: .subtitleColor, img: "feed_video_unlike_new", selectedImg: "feed_video_like")
        self.addSubview(likeBtn!)
        likeBtn?.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kMargin)
            make.right.equalTo(favoriteBtn?.snp.left ?? 0).offset(0)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        }
    
    
        titleLabel = UILabel(withText:"" , fontSize: 14, color: .titleColor)
        self.addSubview(titleLabel!)
        titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        titleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(imgView?.snp.top ?? 0)
            make.left.equalTo(imgView?.snp.right ?? 0).offset(kMargin)
            make.right.equalToSuperview().offset(kMarginRight)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
 
}
