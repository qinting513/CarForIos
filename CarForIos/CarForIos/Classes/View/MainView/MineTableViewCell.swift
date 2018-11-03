//
//  MineTableViewCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    var nameLabel : UILabel?
    var redDotView : UIView?
    var mAccessoryView: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        let nameLabel = UILabel(withText: "我的收藏", fontSize: 17, color: .black)
        self.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(60)
        })
        self.nameLabel = nameLabel
        
       let redDot = UIView()
        self.addSubview(redDot)
        redDot.backgroundColor = .red
        let redDotWH : CGFloat = 10.0
        redDot.layer.masksToBounds = true
        redDot.layer.cornerRadius = redDotWH * 0.5
        redDot.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(redDotWH)
            make.right.equalToSuperview().offset(-35)
        }
        redDot.isHidden = true
        self.redDotView = redDot
        
        let arrowBtn = UIButton(title: "", titleColor: UIColor.white, img: "aui-icon-right", selectedImg: "aui-icon-right", fontSize: 1, bgColor: UIColor.clear, target: nil, action: nil)
        contentView.addSubview(arrowBtn!)
        arrowBtn?.snp.makeConstraints({(make) in
            make.width.equalTo(34)
            make.centerY.right.equalToSuperview()
            make.height.equalTo(34)
        })
        mAccessoryView = arrowBtn
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lineColor
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}
