//
//  TopImageBottomContentCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class TopImageBottomContentCell: BaseHomeCell {
    
    
    func setupUI() {
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = RGB(r: 248, g: 248, b: 248)
        self.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(15)
        }
        mTopLine = seperatorView
        
        imgView = UIImageView()
        imgView?.image = getImageWithColor(color: .mainColor)
        self.addSubview(imgView!)
        imgView?.snp.makeConstraints({ (make) in
            make.top.equalTo(seperatorView.snp.bottom).offset(0)
            make.left.right.equalToSuperview().offset(0)
            make.height.equalTo(kTopImageHeight)
        })
        
        let title = "玛莎拉蒂 宝马 奔驰 迈巴赫 阿斯顿马丁 阿尔法罗密欧 宾利 兰博基尼 保时捷 别克 比亚迪 法拉利"
         titleLabel = UILabel(withText:title , fontSize: 16, color: UIColor.black,numberOfLines:2)
        var titleHeight = getTextHeigh(textStr: title, font: 16, width: kScreenWidth - 2*kMargin)
        titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        if titleHeight > 2*20 {
            titleHeight = 2*20
        }
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(imgView?.snp.bottom ?? 0).offset(kMargin)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(titleHeight)
        }
        
        let summary = "阿尔法罗密欧 宾利 兰博基尼 保时捷 别克 比亚迪 法拉利 五菱宏光 宝骏730 玛莎拉蒂 宝马 奔驰 迈巴赫 阿斯顿马丁 东风雪铁龙 长城 红旗 阿尔法罗密欧 宾利 兰博基尼 保时捷 别克 比亚迪 法拉利 五菱宏光 宝骏730 玛莎拉蒂 宝马 奔驰 迈巴赫 阿斯顿马丁 东风雪铁龙 长城 红旗 阿尔法罗密欧 宾利 兰博基尼 保时捷 别克 比亚迪 法拉利 五菱宏光 宝骏730 玛莎拉蒂 宝马 奔驰 迈巴赫 阿斯顿马丁 东风雪铁龙 长城 红旗"
         summaryLabel = UILabel(withText:summary , fontSize: 12, color: UIColor.lightGray,numberOfLines:3)
        var summaryLabelH = getTextHeigh(textStr: summary, font: 12, width: kScreenWidth - 2*kMargin)
        if summaryLabelH > 3*15 {
            summaryLabelH = 3*15
        }
        self.addSubview(summaryLabel!)
        summaryLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel?.snp.bottom ?? 0).offset(2)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(-kMargin)
            make.height.equalTo(summaryLabelH)
        }
        
        timeLabel = UILabel(withText: "5小时前", fontSize: kFavoriteBtnFont, color: .subtitleColor, numberOfLines: 1)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-kMargin-10)
            make.left.equalToSuperview().offset(kMargin)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        })
        
        favoriteBtn = UIButton(title: "1235674", titleColor: .subtitleColor,
                           img: "feed_video_unlike", selectedImg: "feed_video_like", target: self, action: #selector(favoriteBtnClick))
        self.addSubview(favoriteBtn!)
        favoriteBtn?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-kMargin)
            make.bottom.equalToSuperview().offset(-kMargin-10)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        }
        
        likeBtn = UIButton(title: "1235674", titleColor: .subtitleColor,
                              img: "feed_video_unlike", selectedImg: "feed_video_like", target: self, action: #selector(likeBtnClick))
        self.addSubview(likeBtn!)
        likeBtn?.snp.makeConstraints { (make) in
            make.right.equalTo(favoriteBtn?.snp.left ?? 0).offset(0)
            make.bottom.equalToSuperview().offset(-kMargin-10)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .backgroundColor
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
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
