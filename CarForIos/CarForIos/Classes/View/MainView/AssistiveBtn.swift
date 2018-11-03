//
//  AssistiveBtn.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit

enum  AssistiveTouchType : Int {
    case None = 0 //自动识别贴边
    case Left     //拖动停止之后，自动向左贴边
    case Right    //拖动停止之后，自动向右贴边
    case AnyLocation // 任意位置
}

class AssistiveBtn: UIButton {
   
    var assistiveType : AssistiveTouchType? = .None
    
    var mNewMsgPoint: UIView?
    
    var mHaveNewMsg: Bool = false {
        didSet {
            if mHaveNewMsg {
                mNewMsgPoint?.isHidden = false
            } else {
                mNewMsgPoint?.isHidden = true
            }
        }
    }
    
    static let shared = AssistiveBtn()
    
    
    init() {
        super.init(frame: .zero)
        
        let btnWH: CGFloat = 50
        setBackgroundImage(UIImage(named: "MenuNormal"), for: .normal)
        setBackgroundImage(UIImage(named: "MenuOpen"), for: .selected)
        assistiveType = .AnyLocation
        frame = CGRect(x: 30, y: kScreenHeight - 35 - kNavBarHeight, width: btnWH, height: btnWH)
        
        let newMsgPoint = UIImageView(image: UIImage(named: "IMG_NewMsg"))
        addSubview(newMsgPoint)
        newMsgPoint.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.width.height.equalTo(8)
        }
        mNewMsgPoint = newMsgPoint
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
