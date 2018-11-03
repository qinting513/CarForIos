//
//  AppDelegate+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/16.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    
    @objc func floatingButtonClick(button:UIButton){
        button.isSelected = !button.isSelected
        if button.isSelected {
            UIView.animate(withDuration: 0.5) {
                UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.menuView)
            }
            self.menuView.menuViewSelectClosure = { [weak self] (index) in
                self?.menuViewDidSelect(index: index)
              AssistiveBtn.shared.removeFromSuperview()
              UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
              AssistiveBtn.shared.isSelected = false
            }
        }else{
            self.menuView.removeFromSuperview()
        }
        
    }
    
    @objc func setFloatingBtnVisible(isShow:Bool){
        print("控制器：" + "\(self.window?.center.x ?? 0 )")
        if isShow {
            UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
        }else{
            AssistiveBtn.shared.removeFromSuperview()
        }
    }
    
    @objc func changePosition(pan:UIPanGestureRecognizer){

       let panView = pan.view
        setLocation(assistiveType: AssistiveBtn.shared.assistiveType)
        if pan.state == .began || pan.state == .changed {
            let translation = pan.translation(in: self.window)
            panView?.center = CGPoint(x: (panView?.center.x ?? 0) + translation.x, y: (panView?.center.y ?? 0) + translation.y )
            pan.setTranslation(CGPoint.zero, in: self.window)
        }
        
        if pan.state == .ended {
            setLocation(assistiveType: AssistiveBtn.shared.assistiveType)
        }
    }
    
  
    func setLocation(assistiveType : AssistiveTouchType?){

        guard let assistiveType = assistiveType else{
            return
        }
        
        let floatingBtn = AssistiveBtn.shared

        let btnY = floatingBtn.frame.origin.y
        let btnW = floatingBtn.frame.size.width
        let btnH = floatingBtn.frame.size.height

        switch assistiveType {
            case .None : do {
                   //自动识别贴边
                if  AssistiveBtn.shared.center.x  >= (AssistiveBtn.shared.superview?.frame.size.width ?? 0) * 0.5 {
                    UIView.animate(withDuration: 0.5) {
                         //按钮靠右自动吸边
                        let btnX = (floatingBtn.superview?.frame.size.width ?? kScreenWidth) - btnW
                        AssistiveBtn.shared.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                    }
                }else{
                    UIView.animate(withDuration: 0.5) {
                        //按钮靠左自动吸边
                        AssistiveBtn.shared.frame = CGRect(x: 0, y: btnY, width: btnW, height: btnH)
                    }
                }
            }
            case .Left : do{
                UIView.animate(withDuration: 0.5) {
                    //按钮靠左自动吸边
                    AssistiveBtn.shared.frame = CGRect(x: 0, y: btnY, width: btnW, height: btnH)
                }
            }
            case .Right : do {
                UIView.animate(withDuration: 0.5) {
                    //按钮靠右自动吸边
                    let btnX = (floatingBtn.superview?.frame.size.width ?? kScreenWidth) - btnW
                    AssistiveBtn.shared.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                }
            }
            case .AnyLocation : do{
                        var isOver : Bool = false
                        var frame = CGRect.zero
                        if floatingBtn.frame.origin.x < 0 {
                            frame = CGRect(x: 0, y: btnY, width: btnW, height: btnH)
                            isOver = true
                        }else if (floatingBtn.frame.origin.x + floatingBtn.frame.size.width > kScreenWidth) {
                            frame = CGRect(x: kScreenWidth - btnW, y: btnY, width: btnW, height: btnH)
                            isOver = true
                        }

                        //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
                        let defaultNaviHeight : CGFloat = 64.0
                        let judgeSuperViewHeight : CGFloat = kScreenHeight - defaultNaviHeight

                        //y轴上下极限坐标
                        if floatingBtn.frame.origin.y < defaultNaviHeight {
                            //按钮顶部越界
                            frame = CGRect(x: floatingBtn.frame.origin.x, y: defaultNaviHeight, width: btnW, height: btnH)
                            isOver = true
                        }else if btnY > judgeSuperViewHeight {
                            //按钮底部越界
                            frame = CGRect(x:floatingBtn.frame.origin.x, y: kScreenHeight - btnH, width: btnW, height: btnH)
                            isOver = true
                        }

                        if isOver {
                             //如果越界-跑回来
                            UIView.animate(withDuration: 0.5) {
                                AssistiveBtn.shared.frame = frame
                            }
                        }
             }

         }

    }
    
    func menuViewDidSelect(index:Int){
        if index == self.currentSelectIndex {
            self.menuView.removeFromSuperview()
            return ;
        }
        self.currentSelectIndex = index
        
        //        ["首页","玩具","玩车","我的","关于我们"]
        switch index {
        case 0: do {
            UIApplication.shared.keyWindow?.rootViewController? = HomeNavigationController(rootViewController: HomeViewController())
            }
        case 1: do {
            UIApplication.shared.keyWindow?.rootViewController? = HomeNavigationController(rootViewController: PlayCarViewController())
            }
        case 2: do {
            UIApplication.shared.keyWindow?.rootViewController? = HomeNavigationController(rootViewController: ToyViewController())
            }
        case 3: do {
            UIApplication.shared.keyWindow?.rootViewController? = HomeNavigationController(rootViewController: MineViewController())
            }
        case 4: do {
            UIApplication.shared.keyWindow?.rootViewController? = HomeNavigationController(rootViewController: AboutUsViewController())
            }
        default: break
            
        }
    }
}
