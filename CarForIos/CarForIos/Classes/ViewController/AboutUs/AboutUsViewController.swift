//
//  AboutUsViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/16.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class AboutUsViewController: UIViewController{

    lazy var playHomeLabel :UIImageView = {
        let label = UIImageView(image: UIImage(named: "IMG_Login_logo"))
        return label
    }()
    
    lazy var textView : UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        let font :CGFloat = 16.0
        textView.font = UIFont.systemFont(ofSize: font)
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        self.view.addSubview(textView)
        textView.snp.makeConstraints({ (make) in
            make.top.equalTo(playHomeLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        })
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "关于我们"
        //view.backgroundColor = UIColor.white
        
        view.addSubview(playHomeLabel)
        playHomeLabel.backgroundColor = .white
        playHomeLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(180)
            make.width.equalTo(120)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        })
        
        let text = "工作、家庭，你承受了很多，辛苦了。\n何不来这里享受片刻快乐？\n我们是一群敢玩会玩的急先锋，\n每天都在提升着自己的生活品质。\n希望我们每天的胡闹，\n能给你带来一些灵感火花。"
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 10
        textView.backgroundColor = .backgroundColor
        let attribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),
                         NSAttributedStringKey.paragraphStyle : para]
        textView.attributedText = NSAttributedString(string: text, attributes: attribute)
        textView.textAlignment = .center
        textView.textColor = HexString(hex: "#939393")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
