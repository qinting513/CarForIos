//
//  ImgTagLableView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/15.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import YYKit

class ImgTagLableView: UIView {

    var mTitleLable: UILabel?
    var mDescriptionLabel: YYTextView?
    var mDescriptionView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let contentView = UIView()
        contentView.backgroundColor = .backgroundColor
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        mDescriptionView = contentView
        
        let titleLabel = UILabel(font: .titleFont, color: .white, alignment: .center)
        titleLabel.text = "描述"
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true
        titleLabel.backgroundColor = .mainColor
        addSubview(titleLabel)
        mTitleLable = titleLabel
        
        let descriptionLabel = YYTextView()
        descriptionLabel.isUserInteractionEnabled = false
        descriptionLabel.backgroundColor = .backgroundColor
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .subtitleColor
        contentView.addSubview(descriptionLabel)
        mDescriptionLabel = descriptionLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mDescriptionView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalToSuperview().offset(22)
        })
        
        mTitleLable?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(80)
        })
        
        mDescriptionLabel?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(44)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginLeft)
            make.right.equalToSuperview().offset(kMarginRight)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
