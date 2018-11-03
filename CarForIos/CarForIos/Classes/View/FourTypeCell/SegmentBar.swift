//
//  segmentView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/13.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

///  知 与 解 2个菜单选项View
class  SegmentBar: UIView {
    
    var titles : [String]? = ["知","解"] {
        didSet {
            self.leftBtn?.setTitle(titles?.first, for: .normal)
            self.rightBtn?.setTitle(titles?.last, for: .normal)
        }
    }
    fileprivate var bottomLine : UIView?
    fileprivate var selectedButton : UIButton?
    ///按钮点击的block回调
    var segmentButtonClickCallBack: ((_ index:Int)->())?
    var leftBtn:UIButton?
    var rightBtn:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let titles = titles else {
            return
        }
        
        backgroundColor = .white
        let width = kScreenWidth / 2.0
        for (index,title) in titles.enumerated(){
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 16)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(.mainColor, for: .selected)
            addSubview(button)
            //button.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: self.frame.size.height)
            button.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(width*CGFloat(index))
                make.width.equalTo(width)
                make.height.equalTo(30)
                make.bottom.equalToSuperview().offset(-2.5)
            }
            button.addTarget(self, action: #selector(segmentButtonClick), for: .touchUpInside)
            button.tag = index
            if index == 0 {
                button.isSelected = true
                self.leftBtn = button
                selectedButton = button
                //bottomLine = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 2, width: width, height: 2.5))
                bottomLine = UIView()
                addSubview(bottomLine!)
                bottomLine?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview()
                    make.width.equalTo(width)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(2.5)
                })
                bottomLine?.backgroundColor = .mainColor
            }else{
                self.rightBtn = button
            }
        }
    }
    
    @objc func segmentButtonClick(button:UIButton){
        print("segmentButtonClick: \(button.tag)  \(button.titleLabel?.text ?? "") ")
        self.selectedButton?.isSelected = false
        button.isSelected = true
        self.selectedButton = button
        UIView.animate(withDuration: 0.3) {
           self.bottomLine?.mj_x = button.mj_x
        }
        
        if let block = self.segmentButtonClickCallBack {
            block(button.tag)
        }
    }
    
   public func setScrollViewOffset(offset:CGFloat){
         bottomLine?.mj_x = offset / 2.0
        if offset > kScreenWidth / 4.0 {
          self.rightBtn?.isSelected = true
          self.leftBtn?.isSelected = false
        }else{
          self.rightBtn?.isSelected = false
          self.leftBtn?.isSelected =  true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
