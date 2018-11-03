//
//  WebViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/8.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate {
    
    var mUrlString: String?
    
    var mHtmlString: String?
    
    
    var webView:WKWebView?
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: kNavBarHeight, w: kScreenWidth, h: 1))
        self.progressView.tintColor = .mainColor      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor  = UIColor.white
        
        setUpWKwebView()
    }
    // 创建webview
    func setUpWKwebView() {
        
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.addSubview(webview)
        view.addSubview(progressView)
        webView = webview
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if (mUrlString != nil) {
            webView?.load(URLRequest(url: URL(string: mUrlString!)!))
            return
        }
        
        if (mHtmlString != nil) {
            webView?.loadHTMLString(mHtmlString!, baseURL: nil)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //  加载进度条
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.webView?.estimatedProgress) ?? 0), animated: true)
            if (webView?.estimatedProgress ?? 0.0)  >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        
    }
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        webView?.uiDelegate = nil
        webView?.navigationDelegate = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
