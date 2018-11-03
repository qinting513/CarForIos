//
//  CommonInput.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import YYKit
import SwiftRichString

class CommonInput: UIView {

    var mInputTextField : YYTextView?
    var mSendBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lineColor
        addSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        let inputTextField = YYTextView()
        addSubview(inputTextField)
        inputTextField.placeholderText = "发表评论..."
        inputTextField.placeholderFont = SystemFonts.PingFangSC_Regular.font(size: 16)
        inputTextField.placeholderTextColor = HexString(hex: "D7D7D7")
        mInputTextField = inputTextField
        inputTextField.textColor = .black
        inputTextField.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
        inputTextField.textContainerInset = UIEdgeInsetsMake(10,15, 0, 0);
        inputTextField.returnKeyType = .send

        let sendBtn = UIButton()
        //sendBtn.setImage(UIImage(named: "InputSendImage"), for: .normal)
        sendBtn.setCornerRadius(radius: 5)
        sendBtn.setTitle("发布", for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sendBtn.setBackgroundColor(.white, forState: .normal)
        sendBtn.isEnabled = false
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.borderColor = UIColor.lineColor.cgColor
        sendBtn.setTitleColor(.lineColor, for: .normal)

        sendBtn.imageView?.tintColor = .mainColor
        addSubview(sendBtn)
        mSendBtn = sendBtn
    }
    
    override func layoutSubviews() {
        
        
        
        mInputTextField?.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-65)
        }
        
        mSendBtn?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(kMarginRight)
            make.height.equalTo(25)
            make.width.height.equalTo(50)
        }
    }
    

}
