//
//  UIScrollView+Refresh.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    /** 添加头部刷新 */
    func addHeaderRefresh(_ block:@escaping MJRefreshComponentRefreshingBlock){
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header?.setTitle("正在加载...", for: .refreshing)
        header?.setTitle("松开即可刷新", for: .pulling)
        header?.setTitle("下拉刷新", for: .idle)
        header?.lastUpdatedTimeLabel.isHidden = true
        self.mj_header = header
    }
    
    /** 添加脚部自动刷新 */
    func addAutoFooterRefresh(_ block:@escaping MJRefreshComponentRefreshingBlock){
        let footer = MJRefreshAutoFooter(refreshingBlock: block)
        self.mj_footer = footer
    }
    
    /** 添加脚步返回刷新 */
    func addBackFooterRefresh(_ block:@escaping MJRefreshComponentRefreshingBlock){
        let footer = MJRefreshBackNormalFooter(refreshingBlock: block)
        footer?.setTitle("Loading…", for: .refreshing)
        footer?.setTitle("松开即可刷新", for: .pulling)
        footer?.setTitle("人家都被你看光了", for: .noMoreData)
        self.mj_footer = footer
    }
    
    /** 结束头部刷新 */
    func endRefresh(){
        OperationQueue.main.addOperation {
            if self.mj_header != nil {
                self.mj_header.endRefreshing()
            }
            if self.mj_footer != nil {
                self.mj_footer.endRefreshing()
            }
        }
    }
    
    /** 结束头部刷新 */
    func endHeaderRefresh(){
        OperationQueue.main.addOperation {
            if self.mj_header != nil {
                self.mj_header.endRefreshing()
            }
        }
    }
    
    /** 结束脚部刷新 */
    func endFooterRefresh(){
        OperationQueue.main.addOperation {
            if self.mj_footer != nil {
                self.mj_header.endRefreshing()
            }
        }
    }
    
    /** 开始头部刷新 */
    func beginHeaderRefresh(){
        OperationQueue.main.addOperation {
            if self.mj_header != nil {
                self.mj_header.beginRefreshing()
            }
        }
    }
    /** 开始脚部刷新 */
    func beginFooterRefresh(){
        OperationQueue.main.addOperation {
            if self.mj_footer != nil {
                self.mj_footer.beginRefreshing()
            }
        }
    }
    
    /** 结束脚步刷新并设置没有更多数据 */
    func endFooterRefreshWithNoMoreData(){
        OperationQueue.main.addOperation {
            if self.mj_footer != nil {
                self.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    
    /** 消除没有更多数据的状态 */
    func resetNoMoreData(){
        OperationQueue.main.addOperation {
            if self.mj_footer != nil {
                self.mj_footer.resetNoMoreData()
            }
        }
    }
}
