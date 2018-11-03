//
//  LoginViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/17.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SVProgressHUD
import EZSwiftExtensions


class LoginViewController: UIViewController {

    private var mLoginView: LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavBarHidden = false
        title = "登录"
        navBar?.backgroundColor = .white
        
        view.backgroundColor = .backgroundColor
        
        let backBtn = UIButton()
        backBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        backBtn.setBackgroundImage(UIImage(named: "IMG_Right"), for: .normal)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backBtnItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(wechatLoginSuccess), name: Notification.Name(kWechatLoginDidSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(weiboLoginSuccess), name: Notification.Name(kWeiboLoginDidSuccess), object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGesture)
        
        let loginView = LoginView(frame: .zero)
        view.addSubview(loginView)
        loginView.snp.makeConstraints({ (make) in
            make.left.right.height.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        })
        mLoginView = loginView
        
        
        loginView.mLoginInputView?.mCodeBtn?.addTarget(self, action: #selector(codeBtnAction), for: .touchUpInside)
        loginView.mLoginBtn?.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        loginView.mCancelBtn?.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        
        loginView.mWeiboBtn?.addTarget(self, action: #selector(weiboLogin), for: .touchUpInside)
        loginView.mWechatBtn?.addTarget(self, action: #selector(wechatLogin), for: .touchUpInside)
    }
    
    //MARK : 微博登录
    @objc func weiboLogin(){
        let request = WBAuthorizeRequest()
        request.scope = "all"
        // 此字段的内容可自定义, 在请求成功后会原样返回, 可用于校验或者区分登录来源
        //        request.userInfo = ["": ""]
        request.redirectURI = "https://weibo.com"
        
        WeiboSDK.send(request)
    
    }
    
    @objc func wechatLogin(){
        if WXApi.isWXAppInstalled() {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "App"
            WXApi.send(req)
            
        }
    }
    
    @objc func wechatLoginSuccess(noti: Notification) {
        let code = noti.userInfo!["code"] as! String
        let bind_account = [
            "type": "WX",
            "code": code,
            ]
        let params = [
            "client_type": "IOS",
            "bind_account" : bind_account
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_Login, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            print(result)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 获取 token, 如果 token 存在, 说明登录成功
                let userToken = result["rsp_content"]["token"].stringValue
                if userToken.length > 1 {
                    UserDefaults.standard.set(true, forKey: Key_ISLogined)
                    UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                    UserInfo.current.initWith(json: result["rsp_content"])
                    self?.showSuccess(with: "登录成功")
                    self?.cancelBtnAction()
                }
                
                // 第三方未绑定用户, 跳转绑定手机号页面
                else {
                    let bind_type = result["rsp_content"]["bind_type"].stringValue
                    let bind_id = result["rsp_content"]["bind_id"].stringValue
                    let bindVC = BindViewController()
                    bindVC.mBindType = bind_type
                    bindVC.mBindId = bind_id
                    bindVC.mCode = code
                    bindVC.mIsWechat = true
                    self?.pushVC(bindVC)
                }
            } else {
                self?.showError(with: "微信授权失败")
            }
        }
    }
    
    @objc func weiboLoginSuccess(noti: Notification) {
        let access = noti.userInfo!["access"] as! String
        let uid = noti.userInfo!["uid"] as! String
        
        let bind_account = [
            "type": "WEIBO",
            "access_token": access,
            "uid": uid,
            ]
        let params = [
            "client_type": "IOS",
            "bind_account" : bind_account
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_Login, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 获取 token, 如果 token 存在, 说明登录成功
                let userToken = result["rsp_content"]["token"].stringValue
                if userToken.length > 1 {
                    UserDefaults.standard.set(true, forKey: Key_ISLogined)
                    UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                    UserInfo.current.initWith(json: result["rsp_content"])
                    self?.showSuccess(with: "登录成功")
                    self?.cancelBtnAction()
                }
                
                // 第三方未绑定用户, 跳转绑定手机号页面
                else {
                    let bind_type = result["rsp_content"]["bind_type"].stringValue
                    let bind_id = result["rsp_content"]["bind_id"].stringValue
                    let bindVC = BindViewController()
                    bindVC.mBindType = bind_type
                    bindVC.mBindId = bind_id
                    bindVC.mAccessToken = access
                    self?.pushVC(bindVC)
                }
            } else {
                self?.showError(with: "微博授权失败")
            }
        }
    }
    
    
    @objc func tapGestureAction() {
        UIView.animate(withDuration: 0.5) {
            self.mLoginView?.endEditing(true)
        }
    }
    
    @objc func codeBtnAction(send: UIButton) {
        
        let phoneNumber = mLoginView?.mLoginInputView?.mTellNumberTextField?.text
        let isPhone: Bool = isPhoneNumber(phoneNumber!)
        if !isPhone {
            self.showError(with: "请输入正确的手机号码")
            return
        }
        
        // 倒计时
        send.countDown(count: 60)
        
        let params = [
            "type": "user_login",
            "mobile": phoneNumber!,
        ]
        
        RequestManager.shared.Post(URLString: URL_SmsCode, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "发送验证码成功")
            } else {
                SVProgressHUD.showError(withStatus: result["msg"].stringValue)
            }
            
        }
    }
    @objc func loginBtnAction() {
        
        let phoneNumber = mLoginView?.mLoginInputView?.mTellNumberTextField?.text
        let isPhone: Bool = isPhoneNumber(phoneNumber!)
        if !isPhone {
            self.showError(with: "请输入正确的手机号码")
            return
        }
        
        let code = mLoginView?.mLoginInputView?.mCodeNumberTextField?.text ?? ""
        if code.length < 1 {
            self.showError(with: "请输入正确的手机号码")
            return
        }
        
        let User_UIID = UIDevice.current.identifierForVendor?.uuidString
        let iosVersion = UIDevice.current.systemVersion
        let client_id = User_UIID! + "," + iosVersion
        
        let params = [
            "mobile": phoneNumber!,
            "sms_code": code,
            "client_type": "IOS",
            "client_id": client_id
            ]
        
        RequestManager.shared.Post(URLString: URL_Login, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                UserDefaults.standard.set(true, forKey: Key_ISLogined)
                UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                UserInfo.current.initWith(json: result["rsp_content"])
                self?.showSuccess(with: "登录成功")
                
                if let name = UserInfo.current.nickname {
                    if name.isBlank {
                        self?.pushVC(PerfectUserInfoViewController())
                    } else {
                        self?.cancelBtnAction()
                    }
                } else {
                    self?.pushVC(PerfectUserInfoViewController())
                }
            } else {
                self?.showError(with: result["sub_msg"].stringValue)
            }
        }
    }
    
    @objc func cancelBtnAction() {
        UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
