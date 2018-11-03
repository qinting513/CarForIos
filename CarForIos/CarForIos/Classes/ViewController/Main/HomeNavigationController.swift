//
//  HomeNavigationController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/11.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    var mShowMenuBtnClassArr = [HomeViewController.className,
                                SearchViewController.className,
                                PlayCarViewController.className,
                                ToyViewController.className,
                                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
         if mShowMenuBtnClassArr.contains(viewController.className) {
                // 显示菜单按钮
              UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
         } else {
                // 隐藏菜单按钮
             AssistiveBtn.shared.removeFromSuperview()
        }
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navBar?.tintColor = UIColor.mainColor
        viewController.navBar?.backIndicatorImage = UIImage(named: "IMG_Right")
        viewController.navBar?.backIndicatorTransitionMaskImage = UIImage(named: "IMG_Right")
        viewController.navigationItem.backBarButtonItem = backItem;
        
        viewController.view.backgroundColor = .backgroundColor
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        /// 一定先去super。pop出控制器 再去看此时的viewControllers的个数，等于1说明回到第一级页面了
        let vc = super.popViewController(animated: animated)
        if viewControllers.count == 1 {
            // 显示菜单按钮
            UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
        } else {
            // 隐藏菜单按钮
            AssistiveBtn.shared.removeFromSuperview()
        }
        
       return vc
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

