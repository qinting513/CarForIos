//
//  UITableView+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/25.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class NoDataView: UIView {
    var mImageView: UIImageView?
    
    var mDescriptionLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageview = UIImageView()
        addSubview(imageview)
        imageview.image = UIImage(named: "IMG_Noti_NoData")
        imageview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(204)
            make.height.equalTo(174)
        }
        
        let des = UILabel()
        des.text = "暂时没有收藏"
        des.font = SystemFonts.PingFangSC_Regular.font(size: 18)
        des.textColor = HexString(hex: "939393")
        des.textAlignment = .center
        addSubview(des)
        des.snp.makeConstraints { (make) in
            make.top.equalTo(imageview.snp.bottom).offset(kMarginTop)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableView {
    
    func showNodata(_ title: String?=nil) {
        
        // 删除原有的图层
        subviews.forEach { (view) in
            if view.tag == 10086 {
                view.removeFromSuperview()
            }
        }
        
        let nodataView = NoDataView(frame: UIScreen.main.bounds)
        nodataView.tag = 10086
        addSubview(nodataView)
        nodataView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if let des = title {
            nodataView.mDescriptionLabel?.text = des
        }
    }
    
    func hidenNodata() {
        // 删除原有的图层
        subviews.forEach { (view) in
            if view.tag == 10086 {
                view.removeFromSuperview()
            }
        }
    }
}
