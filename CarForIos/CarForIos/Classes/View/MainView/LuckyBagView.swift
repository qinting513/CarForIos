//
//  LuckyBagView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/1.
//  Copyright © 2018 chilunyc. All rights reserved.
//
//  福袋页面



import UIKit
import SnapKit
import SwiftRichString

class LuckyBagView: UIView {
    
    var mBackgroundImageView: UIImageView?
    
    var mLuckyBag: UIImageView?
    
    var mAddButton: UIButton?

    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        let backgroundImageView = UIImageView(image: getImageWithColor(color: RGBA(r: 0, g: 0, b: 0, a:0.8)))
        addSubview(backgroundImageView)
        backgroundImageView.alpha = 0.98
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mBackgroundImageView = backgroundImageView
        
        let luckyBag = UIImageView(image: UIImage(named: "icon_lucky_bag"))
        backgroundImageView.addSubview(luckyBag)
        luckyBag.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
         mLuckyBag = luckyBag
        
        
        let addBtn = UIButton()
//        addBtn.setTitle("收入囊中", for: .normal)
//        addBtn.setTitleColor(.red, for: .normal)
//        addBtn.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 20)
        addBtn.setBackgroundImage(UIImage(named: "icon_lucky_bag_get"), for: .normal)
        backgroundImageView.addSubview(addBtn)
        addBtn.layer.cornerRadius = 5
        addBtn.layer.masksToBounds = true
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(luckyBag.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        mAddButton = addBtn
    }
    
}
