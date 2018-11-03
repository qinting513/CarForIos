//
//  OneItemCollectionViewCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString
import YYKit

class OneItemCollectionViewCell: UICollectionViewCell {
    
    public var favoriteBtn : UIButton?
    public var likeBtn : UIButton?
    
    var mBgView: UIView?
    
    var mImageView : UIImageView?
    var mTitleLabel : YYLabel?
    var mTimeLabel : UILabel?
    
    var indexPathRow : Int? = 0
    var isKnow : Bool? = false
    
    func setupUI(frame: CGRect) {
        

        // 该层主要设置圆角 masksToBounds 设置为 true 后, shadow 相关属性不会生效
        // 同时使用阴影 + 圆角的一个办法就是 底层再写个 view 设置圆角

        let bgViwe = UIView()
        bgViwe.backgroundColor = UIColor.white
        bgViwe.layer.cornerRadius = 5
        bgViwe.layer.shadowColor = HexString(hex: "#ececec").cgColor
        bgViwe.layer.shadowOpacity = 1.0
        bgViwe.layer.shadowOffset = CGSize(width: 0, height: 5)
        bgViwe.layer.shadowRadius = 4
        bgViwe.layer.masksToBounds = false
        
        contentView.addSubview(bgViwe)
        bgViwe.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        
        let imgView = UIImageView()
        imgView.image = getImageWithColor(color:  UIColor.lightGray)
        bgViwe.addSubview(imgView)
        imgView.setCornerRadius(radius: 5)
        imgView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(110)
        })
        mImageView = imgView
        
        // 用来遮住图片下面的圆角, 甲方说不能要圆角
        let imageLineView = UIView()
        imageLineView.backgroundColor = .white
        bgViwe.addSubview(imageLineView)
        imageLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(imgView)
            make.height.equalTo(3)
        }

        let titleLabel = YYLabel()
        mTitleLabel = titleLabel
        mTitleLabel?.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.textVerticalAlignment = .top
        titleLabel.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        bgViwe.addSubview(titleLabel)
        titleLabel.layer.masksToBounds = true
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(9)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(kMarginRight)
            make.bottom.equalToSuperview().offset(-35)
        }

        let timeLabel = UILabel(withText: "5小时前", fontSize: kFavoriteBtnFont, color: .subtitleColor, numberOfLines: 1)
        bgViwe.addSubview(timeLabel!)
        timeLabel?.layer.masksToBounds = true
        timeLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.width.equalTo(kFavoriteBtnWidth)
            make.height.equalTo(kFavoriteBtnHeight)
        })
        mTimeLabel = timeLabel

        likeBtn = UIButton(title: "678971", titleColor: .subtitleColor,
                              img: "feed_video_unlike", selectedImg: "feed_video_like")
        bgViwe.addSubview(likeBtn!)
        likeBtn?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.bottom.equalToSuperview().offset(-15)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(kFavoriteBtnHeight)
        }
    }
    
    /// indexPath用于记录哪个cell的点赞、收藏按钮被惦记
    func setupModel(model:HomeModel?, indexPathRow: Int,isKnow:Bool){
        guard let model = model else {
            print("model no value")
            return ;
        }
        self.indexPathRow = indexPathRow
        self.isKnow = isKnow
        mImageView?.setImage(with: URL(string: model.image_url!))
        mTitleLabel?.text = model.push_app_title
        mTimeLabel?.text = model.create_time?.toAgoString()
        likeBtn?.setTitle(String(format: "%ld",model.like_count ), for: .normal)
        likeBtn?.isSelected = model.like == 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
