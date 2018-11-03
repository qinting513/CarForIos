//
//  CommonNoDataCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class CommonNoDataCell: UITableViewCell {
    
    var mNoDataImg: UIImageView?
    
    var mDesLabel: UILabel?
    
    var mIsComment: Bool = false {
        didSet {
            if mIsComment {
                mDesLabel?.text = "暂无评论, 快点参与讨论吧!"
                mNoDataImg?.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(40)
                })
            } else {
                mNoDataImg?.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(180)
                })
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .backgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI() {
        
        let imageview = UIImageView()
        contentView.addSubview(imageview)
        imageview.image = UIImage(named: "IMG_Noti_NoData")
        imageview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(180)
            make.width.equalTo(102)
            make.centerX.equalToSuperview()
            make.height.equalTo(87)
        }
        mNoDataImg = imageview
        
        
        let des = UILabel()
        des.text = ""
        des.font = SystemFonts.PingFangSC_Regular.font(size: 14)
        des.textColor = HexString(hex: "939393")
        des.textAlignment = .center
        contentView.addSubview(des)
        des.snp.makeConstraints { (make) in
            make.top.equalTo(imageview.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        mDesLabel = des
    }
    
}
