//
//  MyStoreViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/17.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SwiftRichString

class MyStoreViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        /// 设置没有轮播图
        self.knowTableViewScrollView?.items = []
        self.segmentBar?.titles = ["顽车","顽技"]
        
        segmentBar?.leftBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 16)
        segmentBar?.rightBtn?.titleLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 16)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        ///放到 viewWillAppear 因为点进详情 取消收藏后 再出来没刷新数据
        headerRefresh()
    }
    
    override func headerRefresh() {
        if self.currentIndex == 0 {
            self.mKnowPageIndex = 1
        } else {
            self.mAnswerPageIndex = 1
        }
        self.requestHomeData(isFooter: false)
    }
    
    override func footerRefresh() {
        if self.currentIndex == 0 {
            self.mKnowPageIndex += 1
        } else {
            self.mAnswerPageIndex += 1
        }
        self.requestHomeData(isFooter: true)
    }

    func requestHomeData(isFooter: Bool) {
        
        let params = [
//            "module": "",
            "module": self.currentIndex == 0 ? "PLAY_CAR" : "TOY" ,
            "page_index": self.currentIndex == 0 ? self.mKnowPageIndex : self.mAnswerPageIndex,
            "page_size": DefaultPageSize,
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_MyFav, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            print("\n 收藏：")
            print(result)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let myFavItemModels = [MyFavItemModel].deserialize(from: toJSONString(arr: itemArr!)) {
                    let homeModels = myFavItemModels.map({ (model) -> HomeModel? in
                        return model?.article
                    })
                    if self?.currentIndex == 0 {
                        if isFooter {
                            self?.knowDatas += homeModels as! [HomeModel]
                        } else {
                            self?.knowDatas = homeModels as! [HomeModel]
                        }
                        self?.knowTableView?.reloadData()
                        self?.knowTableView?.endRefresh()
                    } else {
                        if isFooter {
                            self?.answerDatas += homeModels as! [HomeModel]
                        } else {
                            self?.answerDatas = homeModels as! [HomeModel]
                        }
                        self?.answerTableView?.reloadData()
                        self?.answerTableView?.endRefresh()
                    }
                }
            }
            self?.knowTableView?.endRefresh()
            self?.answerTableView?.endRefresh()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.knowTableView {
            if knowDatas.count == 0 {
                let cell:CommonNoDataCell = CommonNoDataCell(style: .default, reuseIdentifier: CommonNoDataCell.className())
                cell.mDesLabel?.text = "暂时没有收藏"
                cell.mNoDataImg?.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(113)
                })
                return cell
            }
        }else{
            if answerDatas.count == 0 {
                let cell:CommonNoDataCell = CommonNoDataCell(style: .default, reuseIdentifier: CommonNoDataCell.className())
                cell.mNoDataImg?.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(113)
                })
                cell.mDesLabel?.text = "暂时没有收藏"
                return cell
            }
        }
        
        
        var model : HomeModel?
        var isKnow : Bool
        if tableView == self.answerTableView {
            model = self.answerDatas[indexPath.row]
            isKnow = false
        }else{
            model = self.knowDatas[indexPath.row]
            isKnow = true
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LContentRImageCell", for: indexPath) as? LContentRImageCell
        cell?.setupModel(model: model!, indexPathRow:indexPath.row,isKnow: isKnow)
        cell?.homeDelegate = self
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.knowTableView {
            if knowDatas.count == 0 {
                return 300
            }
        }else{
            if answerDatas.count == 0 {
                return 300
            }
        }
        
        return kSmallImgHeight + kMarginTop + -kMarginBottm
    }
    
    
}

