//
//  LoginView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/17.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    public var mLoginInputView : LoginInputView?
    
    public var mLoginBtn    : UIButton?
    public var mCancelBtn   : UIButton?
    public var mWechatBtn   : UIButton?
    public var mWeiboBtn    : UIButton?

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
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
        
        /** Logo Image */
        let logoImage = UIImageView(image: UIImage(named: "IMG_Login_logo"))
        logoImage.contentMode = .scaleAspectFill
        addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(32)
            make.size.equalTo(CGSize(width: 102, height: 87))
        }
        
        /** 输入框 */
        let inputView = LoginInputView(frame: .zero)
        addSubview(inputView)
        inputView.isUserInteractionEnabled = true
        inputView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.right.equalTo(self.snp.right).offset(-30)
            make.left.equalTo(self.snp.left).offset(30)
            make.height.equalTo(82)
        }
        mLoginInputView = inputView
        
        
        let loginBtn = UIButton(frame: .zero)
        addSubview(loginBtn)
        let bgImg = getImageWithColor(color: .mainColor)
        loginBtn.setBackgroundImage(bgImg, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputView)
            make.top.equalTo(inputView.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        mLoginBtn = loginBtn
        
        let bottomLabel = UILabel(frame: .zero)
        addSubview(bottomLabel)
        bottomLabel.text = "社交账号登录"
        bottomLabel.font = .otherFont
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = .subtitleColor
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalToSuperview().offset(-200)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        let bottomLeftLine = UIView(frame: .zero)
        addSubview(bottomLeftLine)
        bottomLeftLine.backgroundColor = .lineColor
        bottomLeftLine.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.right.equalTo(bottomLabel.snp.left).offset(-20)
            make.centerY.equalTo(bottomLabel.snp.centerY)
            make.height.equalTo(1)
        }
        
        let bottomRightLine = UIView(frame: .zero)
        addSubview(bottomRightLine)
        bottomRightLine.backgroundColor = .lineColor
        bottomRightLine.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.left.equalTo(bottomLabel.snp.right).offset(20)
            make.centerY.equalTo(bottomLabel.snp.centerY)
            make.height.equalTo(1)
        }
        
        
        
        let wechatBtn = UIButton(frame: .zero)
        addSubview(wechatBtn)
        wechatBtn.setBackgroundImage(UIImage(named: "wechat"), for: .normal)
        wechatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLabel.snp.bottom).offset(30)
            make.height.width.equalTo(50)
            make.right.equalTo(self.snp.centerX).offset(-30)
        }
        mWechatBtn = wechatBtn
        
        let weiboBtn = UIButton(frame: .zero)
        addSubview(weiboBtn)
        weiboBtn.setBackgroundImage(UIImage(named: "weibo"), for: .normal)
        weiboBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLabel.snp.bottom).offset(30)
            make.height.width.equalTo(50)
            make.left.equalTo(self.snp.centerX).offset(30)
        }
        mWeiboBtn = weiboBtn
    
        
        
        
    }
    
}
