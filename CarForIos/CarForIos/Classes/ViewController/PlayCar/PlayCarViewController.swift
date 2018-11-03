//
//  PlayCarViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/16.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SwiftRichString

class PlayCarViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "顽车"
        knowTableViewScrollView?.items = []
        
        knowTableView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kNavBarHeight + 20)
        answerTableView?.frame = CGRect(x: (knowTableView?.frame.maxX ?? 0), y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kNavBarHeight + 20)
    }

    override func loadData() {
        requestBanner(with: .play_car)
        requestHomeData(with: .play_car, isFooter: false)
        
        segmentBar?.leftBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 16)
        segmentBar?.rightBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 16)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func headerRefresh() {
        if currentIndex == 0 {
            mKnowPageIndex = 1
            requestBanner(with: .play_car)
        } else {
            mAnswerPageIndex = 1
        }
        getUserInfo()
        requestHomeData(with: .play_car, isFooter: false)
    }
    
    override func footerRefresh() {
        if currentIndex == 0 {
            mKnowPageIndex += 1
        } else {
            mAnswerPageIndex += 1
        }
        requestHomeData(with: .play_car, isFooter: true)
    }
}
