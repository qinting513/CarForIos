//
//  HomeViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/10.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SwiftRichString

class HomeViewController: BaseVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        navBar?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBar?.isHidden = false
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        title = "哈哈哈"
        navBar?.isHidden = true

        segmentBar?.leftBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 20)
        segmentBar?.rightBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 20)
        segmentBar?.snp.updateConstraints({ (make) in
            make.height.equalTo(kNavBarHeight)
            make.top.equalToSuperview().offset(0)
        })

        bgScrollView?.frame = CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight - (kNavBarHeight - 44))
        answerTableView?.frame = CGRect(x: (knowTableView?.frame.maxX ?? 0), y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kNavBarHeight + 20)
    }


    override func loadData() {

        requestBanner(with: .home)
        requestHomeData(with: .home, isFooter: false)
    }

    override func headerRefresh() {

        if currentIndex == 0 {
            mKnowPageIndex = 1
            requestBanner(with: .home)
        } else {
            mAnswerPageIndex = 1
        }
        getUserInfo()
        requestHomeData(with: .home, isFooter: false)
    }

    override func footerRefresh() {
        if currentIndex == 0 {
            mKnowPageIndex += 1
        } else {
            mAnswerPageIndex += 1
        }
        requestHomeData(with: .home, isFooter: true)
    }
}
