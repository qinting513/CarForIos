//
//  ShareThirdPartyView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/26.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit

class ShareThirdPartyView: UIView {

    var shareFriendsBtn : UIButton?
    var shareWechatBtn  : UIButton?
    var shareWeiboBtn   : UIButton?
    var cancelBtn       : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .backgroundColor
        isUserInteractionEnabled = true
        
        let shareBtnWH :CGFloat = 50
        let cancelBtnHeight : CGFloat = 50.0
        let btnSpace : CGFloat = (kScreenWidth - 3*shareBtnWH - 2*kMargin) / 2.0
        let bgViewHeight = 4*kMarginTop + shareBtnWH + cancelBtnHeight
        
        let bgView = UIView()
        bgView.backgroundColor = .backgroundColor
        self.addSubview(bgView)
     
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(bgViewHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        let cancelBtn = UIButton(frame: .zero)
        bgView.addSubview(cancelBtn)
        cancelBtn.setTitle("取 消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.setBackgroundImage(getImageWithColor(color: .white), for: .normal)
        cancelBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(cancelBtnHeight)
            make.left.bottom.right.equalToSuperview()
        }
        self.cancelBtn = cancelBtn
        
        let seperatorView = UIView()
        bgView.addSubview(seperatorView)
        seperatorView.backgroundColor = .backgroundColor
        seperatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalTo(0)
            make.bottom.equalTo(cancelBtn.snp.top)
        }
      
        
        ///中间的 Friends
        let friendsBtn = UIButton(frame: .zero)
        bgView.addSubview(friendsBtn)
        friendsBtn.layer.masksToBounds = true
        friendsBtn.layer.cornerRadius = shareBtnWH/2
        friendsBtn.setBackgroundImage(UIImage(named: "friends"), for: .normal)
        friendsBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kMarginTop*2)
            make.height.width.equalTo(shareBtnWH)
            make.centerX.equalTo(self.snp.centerX)
        }
        shareFriendsBtn = friendsBtn
        
        /// 微信
        let wechatBtn = UIButton(frame: .zero)
        bgView.addSubview(wechatBtn)
        wechatBtn.layer.masksToBounds = true
        wechatBtn.layer.cornerRadius = shareBtnWH/2
        wechatBtn.setBackgroundImage(UIImage(named: "wechat"), for: .normal)
        wechatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(friendsBtn.snp.top)
            make.height.width.equalTo(shareBtnWH)
            make.centerX.equalTo(self.snp.centerX).offset(-btnSpace)
        }
        shareWechatBtn = wechatBtn
        
       
        
        let weiboBtn = UIButton(frame: .zero)
        bgView.addSubview(weiboBtn)
        weiboBtn.layer.masksToBounds = true
        weiboBtn.layer.cornerRadius = shareBtnWH/2
        weiboBtn.setBackgroundImage(UIImage(named: "weibo"), for: .normal)
        weiboBtn.snp.makeConstraints { (make) in
            make.top.equalTo(friendsBtn.snp.top)
            make.height.width.equalTo(shareBtnWH)
            make.centerX.equalTo(self.snp.centerX).offset(btnSpace)
        }
        shareWeiboBtn = weiboBtn
    
    }

}
