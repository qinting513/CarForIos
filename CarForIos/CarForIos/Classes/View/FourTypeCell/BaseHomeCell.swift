//
//  BaseHomeCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit

class BaseHomeCell: UITableViewCell {

    /// 底部线条
    var mLineView: UIView?
    /// 顶部线条
    var mTopLine: UIView?
    
     var favoriteBtn : UIButton?
     var likeBtn : UIButton?
     var imgView : UIImageView?
     var timeLabel : UILabel?
     var titleLabel : UILabel?
     var summaryLabel : UILabel?
     var indexPathRow : Int? = 0
     var isKnow : Bool? = false
     var homeDelegate : BaseHomeCellDelegate?
    
    
    
    /// indexPath用于记录哪个cell的点赞、收藏按钮被惦记
    func setupModel(model:HomeModel?, indexPathRow: Int,isKnow:Bool){
        guard let model = model else {
            print("model no value")
            return ;
        }
        self.indexPathRow = indexPathRow
        self.isKnow = isKnow
        imgView?.setImage(with: URL(string: model.image_url ?? ""))
        titleLabel?.text = model.title
        titleLabel?.numberOfLines = 2
        timeLabel?.text = model.create_time?.toAgoString()
        
        // 暂不显示收藏按钮
        favoriteBtn?.setTitle(String(format: "%ld",model.fav_count ), for: .normal)
        favoriteBtn?.snp.updateConstraints({ (make) in
            make.width.equalTo(0)
        })

        likeBtn?.setTitle(String(format: "%ld",model.like_count ), for: .normal)
        favoriteBtn?.isSelected = model.like == 1
        likeBtn?.isSelected = model.fav == 1
        
        
        // 和 Android 保持一致, cell 不执行该操作
        likeBtn?.isEnabled = false
        
        if let summary = model.summary {
            summaryLabel?.text = summary
        }
        

        mLineView?.isHidden = !model.showLine
        
        /// 第一张就是大图, 隐藏顶部线条
        mTopLine?.isHidden = model.hidenBigImgTopLine
        mTopLine?.snp.updateConstraints({ (make) in
            make.height.equalTo(model.hidenBigImgTopLine ? 0 : 15)
        })
    }
    
    @objc func favoriteBtnClick(button:UIButton){
        button.isSelected = !button.isSelected
        self.homeDelegate?.homeCellFavoriteBtnClick(indexPathRow: self.indexPathRow ?? 0, isKnow:self.isKnow ,sender: button)
    }
    
    @objc func likeBtnClick(button:UIButton){
        button.isSelected = !button.isSelected
        self.homeDelegate?.homeCellLikeBtnClick(indexPathRow: self.indexPathRow ?? 0, isKnow: self.isKnow, sender: button)
    }
    
}
protocol BaseHomeCellDelegate {
    /// 点赞按钮点击
    func homeCellLikeBtnClick(indexPathRow : Int, isKnow:Bool?, sender: UIButton)
    ///收藏按钮点击
    func homeCellFavoriteBtnClick(indexPathRow : Int, isKnow:Bool?, sender: UIButton)
}
