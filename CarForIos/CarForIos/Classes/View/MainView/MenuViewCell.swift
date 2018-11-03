//
//  MenuViewCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/15.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class MenuViewCell: UITableViewCell {
    
    var mNewMsgView: UIImageView?
    
    var mTitleLable: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        mTitleLable = UILabel()
        mTitleLable?.textColor = .black
        mTitleLable?.backgroundColor = .clear
        mTitleLable?.font = SystemFonts.PingFangSC_Regular.font(size: 20)
        contentView.addSubview(mTitleLable!)
        
        mNewMsgView = UIImageView(image: UIImage(named: "IMG_NewMsg"))
        mNewMsgView?.isHidden = true
        contentView.addSubview(mNewMsgView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mTitleLable?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMargin*2)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        })
        
        mNewMsgView?.snp.makeConstraints({ (make) in
            make.left.equalTo(mTitleLable?.snp.right ?? 0)
            make.centerY.equalTo(mTitleLable?.snp.centerY ?? 0).offset(-3)
            make.width.height.equalTo(8)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
