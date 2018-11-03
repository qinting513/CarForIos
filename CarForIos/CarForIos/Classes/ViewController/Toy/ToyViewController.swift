//
//  ToyViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/1.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ToyViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "顽技"
        
        knowTableView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kNavBarHeight + 20)
        answerTableView?.frame = CGRect(x: (knowTableView?.frame.maxX ?? 0), y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kNavBarHeight + 20)
    }
    
    
    override func loadData() {
        requestBanner(with: .toy)
        requestHomeData(with: .toy, isFooter: false)
    }
    
    override func headerRefresh() {
        if currentIndex == 0 {
            mKnowPageIndex = 1
            requestBanner(with: .toy)
        } else {
            mAnswerPageIndex = 1
        }
        getUserInfo()
        requestHomeData(with: .toy, isFooter: false)
    }
    
    override func footerRefresh() {
        if currentIndex == 0 {
            mKnowPageIndex += 1
        } else {
            mAnswerPageIndex += 1
        }
        requestHomeData(with: .toy, isFooter: true)
    }
}
