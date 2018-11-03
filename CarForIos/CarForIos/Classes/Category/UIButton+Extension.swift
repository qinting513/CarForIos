//
//  UIButton+Extension.swift
//  WeiBo
//
//  Created by chilunyc on 16/9/7.
//  Copyright © 2016年 chilunyc. All rights reserved.
//

import UIKit
import Kingfisher

  //便利初始化器最终一定以调用一个指定初始化器结束
extension UIButton{
 
    convenience init?(title:String,titleColor:UIColor? = UIColor.black, img:String?, selectedImg:String?,fontSize:CGFloat? = kFavoriteBtnFont,bgColor:UIColor? = UIColor.clear, target:AnyObject? = nil,  action:Selector? = nil ){
        
        self.init(type: .custom)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        if let bgColor = bgColor {
            self.backgroundColor = bgColor
        }
        
        if let fontSize = fontSize {
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        if let img = img {
           self.setImage(UIImage(named:img ), for: .normal)
        }
        if let selectedImg = selectedImg {
             self.setImage(UIImage(named:selectedImg ), for: .selected)
        }

        if let action = action {
            self.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    
    func setImage(with url: Resource?) {
        setImage(with: url, placeHolder: Image(named: "DefaultNoData"))
    }
    
    func setImage(with url: Resource?, completionHandler: CompletionHandler? = nil) {
        setImage(with: url, placeHolder: nil, completionHandler: completionHandler)
    }
    
    func setImage(with url: Resource?, placeHolder: Image?=nil) {
        kf.setImage(with: url, for: .normal, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    func setImage(with url: Resource? , placeHolder: Image?=nil, completionHandler: CompletionHandler? = nil) {
        kf.setImage(with: url, for: .normal, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: completionHandler)
    }
}


// 倒计时
extension UIButton {
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
//        // 设置倒计时,按钮背景颜色
//        backgroundColor = .white
        
        var remainingCount: Int = count {
            willSet {
                setTitle("重新发送(\(newValue))", for: .normal)
                
                if newValue <= 0 {
                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
    
    /// 取消连续点击, 默认两秒不能点击
    public func cancelContinuousClicks(){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        delay(2) { [weak self] in
            self?.isEnabled = true
        }
    }
    
    
    private static var ForbidIntervalKey = "ForbidIntervalKey"
    private static var LastClickTimeKey = "LastClickTimeKey"
    
    func startForbidContinuousClick() {
        if let originalMethod: Method = class_getInstanceMethod(self.classForCoder, #selector(UIButton.sendAction)),
            let newMethod: Method = class_getInstanceMethod(self.classForCoder, #selector(UIButton.jf_sendAction(action:to:forEvent:))) {
            method_exchangeImplementations(originalMethod, newMethod)
        }
    }
    
    
    /// 按钮不能被重复点击的时间间隔（默认两秒）
    var forbidInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &UIButton.ForbidIntervalKey) as? TimeInterval {
                return interval
            }
            return 2
        }
        set {
            objc_setAssociatedObject(self, &UIButton.ForbidIntervalKey, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    /// 存储上次点击的时间(默认是1970年的时间)
    private var lastClickDate: Date {
        get {
            if let lastDate = objc_getAssociatedObject(self, &UIButton.LastClickTimeKey) as? Date {
                return lastDate
            }
            return Date.init(timeIntervalSince1970: 0)
        }
        set {
            objc_setAssociatedObject(self, &UIButton.LastClickTimeKey, newValue as Date, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc dynamic func jf_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        if Date().timeIntervalSince(lastClickDate) > forbidInterval {
            self.jf_sendAction(action: action, to: target, forEvent: event)
            lastClickDate = Date()
        }
    }
}
