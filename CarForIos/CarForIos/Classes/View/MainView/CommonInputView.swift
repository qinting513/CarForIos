//
//  CommonInputView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/9.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

class CommonInputView: UIView {
    
    var mTitleLabel: UILabel?
    
    var mInputTextField: UITextField?
    
    var mShowCodeBtn: Bool = false
    
    var mCodeBtn: UIButton?
    
    private var mIndicatior: UILabel?
    private var mBottomLine: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel = UILabel(frame: .zero)
        addSubview(titleLabel)
        mTitleLabel = titleLabel
        
        let indicator = UILabel()
        addSubview(indicator)
        mIndicatior = indicator
        indicator.text = ":"
        
        
        let inptView = UITextField()
        addSubview(inptView)
        mInputTextField = inptView
        
        let codeBtn = UIButton()
        addSubview(codeBtn)
        codeBtn.backgroundColor = .white
        codeBtn.titleLabel?.font = .otherFont
        codeBtn.setTitle("发送验证码", for: .normal)
        codeBtn.setTitleColor(.mainColor, for: .normal)
        mCodeBtn = codeBtn
        
        let bottomline = UIView()
        bottomline.backgroundColor = .lineColor
        addSubview(bottomline)
        mBottomLine = bottomline
    }
    
    override func layoutSubviews() {
        
        mTitleLabel?.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        mIndicatior?.snp.makeConstraints { (make) in
            make.left.equalTo(mTitleLabel?.snp.right ?? 0)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(5)
        }
        
        mInputTextField?.snp.makeConstraints { (make) in
            make.left.equalTo(mIndicatior?.snp.right ?? 0).offset(kMarginLeft)
            if mShowCodeBtn {
                make.right.equalToSuperview().offset(kMarginRight - 100)
            } else {
                make.right.equalToSuperview().offset(kMarginRight)
            }
            make.top.bottom.equalToSuperview()
        }
        
        mCodeBtn?.isHidden = !mShowCodeBtn
        mCodeBtn?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
        }
        
        mBottomLine?.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
