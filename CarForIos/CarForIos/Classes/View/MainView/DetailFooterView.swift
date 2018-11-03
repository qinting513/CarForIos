//
//  DetailFooterView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/20.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import YYKit

class DetailFooterView: UIView {

    var allCommentsBtn : UIButton?
    var textField : UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .lightGray
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){

       let commentInputView = CommentInputView()
        addSubview(commentInputView)
        commentInputView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(1.0)
            make.right.equalToSuperview().offset(-1.0)
            make.height.equalTo(50)
        })
    }

}


/// 评论输入框
class CommentInputView: UIView {
    
    var inputTextField : YYTextView?
    var bottomLineView : UIView?
    var mSendBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()  {
        inputTextField = YYTextView()
        addSubview(inputTextField!)
        inputTextField?.returnKeyType = .send
        inputTextField?.placeholderText = "发表评论..."
        
        
        let sendBtn = UIButton()
        sendBtn.setImage(UIImage(named: "InputSendImage"), for: .normal)
        sendBtn.imageView?.tintColor = .mainColor
        addSubview(sendBtn)
        mSendBtn = sendBtn
    }
    
    override func layoutSubviews() {
        
        inputTextField?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-55)
            make.left.top.bottom.equalToSuperview()
        }
        
        mSendBtn?.snp.makeConstraints { (make) in
            make.left.equalTo(inputTextField?.snp.right ?? 0).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(kMarginRight)
        }
    }
}
