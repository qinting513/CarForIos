//
//  DetailViewController+Extension.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/15.
//  Copyright © 2018 chilunyc. All rights reserved.
//
//


import UIKit
import JavaScriptCore
import SwiftyJSON
import HandyJSON

// 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol SwiftJavaScriptDelegate: JSExport {
    func jsCallApp(_ jsonStr: String)
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func jsCallApp(_ jsonStr: String) {
        NotificationCenter.default.post(name: Notification.Name(kDetailImageTagClickAction), object: self, userInfo: ["jsonString": jsonStr])
    }
}


extension DetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hidenLoading()
        
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
        self.jsContext.setObject(model, forKeyedSubscript: "AppBridge" as NSCopying & NSObjectProtocol)
        
        // 注册到网络Html页面 请设置允许Http请求
        // WebView当前访问页面的链接 可动态注册
        if let curUrl = webView.request?.url {
            self.jsContext.evaluateScript(try? String(contentsOf: curUrl, encoding: String.Encoding.utf8))
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        // 此处会打印一个 error , 因为 webview 还没请求完一个请求, 另外一个请求就开始了, 取消了之前的请求, 回调 Error Domain=NSURLErrorDomain Code=-999 "(null)"
        print("didFailLoadWithURL:\n\(String(describing: webView.request?.url)), \nError:\(error)")
    }
}

// 图片标记点击事件
extension DetailViewController {
    
    @objc func detailImageTagClickAction(noti: Notification) {
        
        
        // 防止重复点击, 先删除以前的, 再添加
        if let subViews = UIApplication.shared.keyWindow?.subviews {
            for view in subViews {
                if view.tag == TAG_CONTROL {
                    view.removeSubviews()
                    view.removeFromSuperview()
                }
            }
        }
        
        let jsonString = noti.userInfo!["jsonString"] as! String
        if let tagModel: ImgTagModel = ImgTagModel.deserialize(from: jsonString) {
            // 跳转页面
            if tagModel.type == .link {
                
                if let url = tagModel.link {
                    UIApplication.shared.openURL(URL(string: url)!)
                }
                
//                let webVC = WebViewController()
//                webVC.mUrlString = tagModel.link
//                webVC.title = tagModel.name
//                pushVC(webVC)
            }
            
            // 查看大图
            else if tagModel.type == .image {
                showImage(with: tagModel.image_url, description: nil)
            }
            
            // 查看标记
            else if tagModel.type == .description {
                showImage(with: nil, description: tagModel.description)
            }
        }
    }
    
    @objc func imageCoverClickAction() {
        mControl.removeAllSubviews()
        mControl.removeFromSuperview()
    }
    
    func showImage(with image: String?=nil, description: String?=nil) {
        
        if let ImageUrl: String = image {
            mControlImageView.setImage(with: URL(string: ImageUrl))
            mControl.addSubview(mControlImageView)
            UIApplication.shared.keyWindow?.addSubview(mControl)
        }
        
        if let content: String = description {
            mControlLableView.mDescriptionLabel?.attributedText = NSAttributedString(string: content)
            mControl.addSubview(mControlLableView)
            UIApplication.shared.keyWindow?.addSubview(mControl)
        }
    }
}
