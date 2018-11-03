//
//  LoginInputView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import SwiftRichString
import UIKit

class LoginInputView: UIView {

    public var mAreaTextField    : UITextField?
    public var mTellNumberTextField : UITextField?
    public var mCodeNumberTextField: UITextField?
    
    public var mTellNumberErrLabel : UIView?
    public var mCodeErrolable : UIView?
    
    public var mCodeBtn     : UIButton?
    
    convenience init(){
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        isUserInteractionEnabled = true
        
        /** 手机号码输入框 */
        let inputView = UIView(frame: CGRect.zero)
        addSubview(inputView)
        inputView.isUserInteractionEnabled = true
        inputView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.height.equalTo(41)
        }
        
        let addLable = UILabel(frame: CGRect.zero)
        addLable.text = "+"
        inputView.addSubview(addLable)
        addLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(inputView.snp.centerY).offset(-2)
            make.left.equalTo(inputView.snp.left).offset(5)
            make.width.equalTo(10)
        }
        
        let areaCodeInput = UITextField(frame: CGRect.zero)
        inputView.addSubview(areaCodeInput)
        areaCodeInput.keyboardType = .numberPad
        areaCodeInput.text = "86"
        mAreaTextField = areaCodeInput
        areaCodeInput.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(addLable.snp.right).offset(4)
            make.width.equalTo(41)
        }
        
        let inputLine = UIView(frame: .zero)
        inputLine.backgroundColor = .lineColor
        inputView.addSubview(inputLine)
        inputLine.snp.makeConstraints { (make) in
            make.left.equalTo(areaCodeInput.snp.right)
            make.top.equalTo(inputView.snp.top).offset(10)
            make.bottom.equalTo(inputView.snp.bottom).offset(-10)
            make.width.equalTo(1)
        }
        
        let tellNumberInput = UITextField(frame: CGRect.zero)
        inputView.addSubview(tellNumberInput)
        tellNumberInput.keyboardType = .numberPad
        mTellNumberTextField = tellNumberInput
        tellNumberInput.placeholder = "请输入手机号码"
        tellNumberInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        tellNumberInput.leftViewMode = .always
        tellNumberInput.addTarget(self, action: #selector(tellnumberInputAction), for: .editingChanged)
        tellNumberInput.snp.makeConstraints { (make) in
            make.left.equalTo(inputLine.snp.right)
            make.top.bottom.equalTo(inputView)
            make.right.equalTo(inputView.snp.right).offset(-100)
        }
        
        let tellNumberErrLable = UIView()
        addSubview(tellNumberErrLable)
        tellNumberErrLable.backgroundColor = .lineColor
        mTellNumberErrLabel = tellNumberErrLable
        tellNumberErrLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputView)
            make.top.equalTo(inputView.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        
        let codeBtn = UIButton(frame: .zero)
        codeBtn.setTitle("发送验证码", for: .normal)
        codeBtn.backgroundColor = .backgroundColor
        codeBtn.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 14)
        codeBtn.setTitleColor(.mainColor, for: .normal)
        mCodeBtn = codeBtn
        inputView.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(inputView.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(41)
        }
        
        
        let codeTextField = UITextField(frame: .zero)
        addSubview(codeTextField)
        codeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        codeTextField.leftViewMode = .always
        codeTextField.placeholder = "请输入验证码"
        mCodeNumberTextField = codeTextField
        codeTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputView)
            make.top.equalTo(tellNumberErrLable.snp.bottom)
            make.height.equalTo(41)
        }
        
        
        let codeBottomLine = UIView()
        addSubview(codeBottomLine)
        codeBottomLine.backgroundColor = .lineColor
        codeBottomLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeTextField)
            make.top.equalTo(codeTextField.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        mCodeErrolable = codeBottomLine
    }
    
    @objc func tellnumberInputAction() {
//        let number = mTellNumberTextField?.text
        //mTellNumberTextField?.textColor = isPhoneNumber(number!) ? UIColor.subtitleColor : UIColor.red
    }
    
}
