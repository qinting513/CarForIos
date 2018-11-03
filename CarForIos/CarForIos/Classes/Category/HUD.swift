//
//  UIView+HUD.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SVProgressHUD

let delayValue = 2.0

extension UIView {
    
    func showError(with Error: String) {
        SVProgressHUD.showError(withStatus: Error)
        SVProgressHUD.dismiss(withDelay: delayValue)
    }
    
    func showSuccess(with Success: String) {
        SVProgressHUD.showSuccess(withStatus: Success)
        SVProgressHUD.dismiss(withDelay: delayValue)
    }
    
    func showLoading() {
        
    }
    
}

extension UIViewController {
    
    func showError(with Error: String) {
        SVProgressHUD.showError(withStatus: Error)
        SVProgressHUD.dismiss(withDelay: delayValue)
    }
    
    func showSuccess(with Success: String) {
        SVProgressHUD.showSuccess(withStatus: Success)
        SVProgressHUD.dismiss(withDelay: delayValue)
    }
    
    func showLoading() {
        SVProgressHUD.show()
        delay(10) {
            SVProgressHUD.dismiss()
        }
    }
    
    func hidenLoading() {
        SVProgressHUD.dismiss()
    }
}
