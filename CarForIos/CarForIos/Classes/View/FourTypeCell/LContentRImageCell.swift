//
//  LContentRImageCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class LContentRImageCell: BaseHomeCell {

    var topSeperatorView: UIView?
    
    func setupUI() {
        
        backgroundColor = .white
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lineColor
        seperatorView.isHidden = true
        self.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(1)
        }
        mLineView = seperatorView
        
        imgView = UIImageView()
        imgView?.image = getImageWithColor(color: UIColor.cyan)
        self.addSubview(imgView!)
        imgView?.snp.makeConstraints({ (make) in
            make.top.equalTo(seperatorView.snp.bottom).offset(kMarginTop)
            make.bottom.equalToSuperview().offset(kMarginBottm)
            make.right.equalToSuperview().offset(kMarginRight)
            make.width.equalTo(kSmallImgWidth)
        })
        imgView?.layer.masksToBounds = true
        imgView?.layer.cornerRadius = 5
        imgView?.layer.shouldRasterize = true
        imgView?.layer.rasterizationScale = UIScreen.main.scale
        
        timeLabel = UILabel(withText: "5小时前", fontSize: kFavoriteBtnFont, color: .subtitleColor, numberOfLines: 1)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-kMargin)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        })
        
//        favoriteBtn = UIButton(title: "", img: "feed_video_unlike", selectedImg: "feed_video_like")
        favoriteBtn = UIButton(title: "", titleColor: .black, img: "feed_video_unlike_new", selectedImg: "feed_video_like")
        self.addSubview(favoriteBtn!)
        favoriteBtn?.snp.makeConstraints { (make) in
            make.right.equalTo(imgView?.snp.left ?? 0).offset(-kMargin)
            make.bottom.equalToSuperview().offset(-kMargin)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        }
        
//        likeBtn = UIButton(title: "", img: "feed_video_unlike", selectedImg: "feed_video_like")
        likeBtn = UIButton(title: "", titleColor: .black, img: "feed_video_unlike_new", selectedImg: "feed_video_like")
        self.addSubview(likeBtn!)
        likeBtn?.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kMargin)
            make.right.equalTo(favoriteBtn?.snp.left ?? 0).offset(0)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(kFavoriteBtnHeight)
        }
        
        let title = "玛莎拉蒂 宝马 奔驰 迈巴赫 阿斯顿马丁 阿尔法罗密欧 宾利 兰博基尼 保时捷 别克 比亚迪 法拉利"
        titleLabel = UILabel(withText:title , fontSize: 14, color: .titleColor)
        titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(imgView?.snp.top ?? 0)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.right.equalTo(imgView?.snp.left ?? 0).offset(-kMargin)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lineColor
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(1)
        }
        mLineView = bottomLine
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
