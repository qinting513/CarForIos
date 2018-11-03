//
//  BindViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/2.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class BindViewController: UIViewController {
    
    // 第三方登录的 类型
    var mBindType: String?
    
    // 第三方登录返回的 id 
    var mBindId: String?
    
    // 微信返回的值
    var mCode: String?
    
    // 微博返回的 access_token
    var mAccessToken: String?
    
    // 微信绑定还是微博绑定
    var mIsWechat: Bool = false
    
    var mInputView : LoginInputView?
    
    var mBindButton : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "绑定手机号"
        view.backgroundColor = .backgroundColor
        isNavBarHidden = false
        
        /** 输入框 */
        let inputView = LoginInputView(frame: .zero)
        view.addSubview(inputView)
        inputView.mCodeNumberTextField?.addTarget(self, action: #selector(codeTextFieldInputAction), for: .editingChanged)
        inputView.mCodeBtn?.addTarget(self, action: #selector(codeButtonAction), for: .touchUpInside)
        inputView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(kNavBarHeight)
            make.right.equalTo(view.snp.right).offset(kMarginRight)
            make.left.equalTo(view.snp.left).offset(kMarginLeft)
            make.height.equalTo(140)
        }
        mInputView = inputView
        
        let bindBtn = UIButton()
        view.addSubview(bindBtn)
        bindBtn.addTarget(self, action: #selector(bindBtnAction), for: .touchUpInside)
        bindBtn.setTitle("保存", for: .normal)
        bindBtn.setTitleColor(.white, for: .normal)
        bindBtn.isEnabled = false
        bindBtn.setBackgroundColor(.lightGray, forState: .disabled)
        bindBtn.setBackgroundColor(.mainColor, forState: .normal)
        bindBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputView)
            make.height.equalTo(40)
            make.top.equalTo(inputView.snp.bottom).offset(20)
        }
        mBindButton = bindBtn


        // Do any additional setup after loading the view.
    }
    
    @objc func codeButtonAction(send: UIButton) {
        
        let phoneNumber = mInputView?.mTellNumberTextField?.text
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
                self?.showError(with: result["msg"].stringValue)
            }
        }
    }
    
    @objc func codeTextFieldInputAction(textField: UITextField) {
        if (textField.text?.length)! > 0 && (mInputView?.mTellNumberTextField?.text?.length)! > 0{
            mBindButton?.isEnabled = true
        } else {
            mBindButton?.isEnabled = false
        }
    }
    
    // 绑定按钮, 登录操作
    @objc func bindBtnAction() {
        // 手机号码
        let phoneNumber = mInputView?.mTellNumberTextField?.text
        // 验证码
        let code = mInputView?.mCodeNumberTextField?.text ?? ""
        // 设备信息
        let User_UIID = UIDevice.current.identifierForVendor?.uuidString
        let iosVersion = UIDevice.current.systemVersion
        let client_id = User_UIID! + "," + iosVersion
        
        // 登录第三方参数
        var bind_account = [
            "type": mBindType,
            "uid": mIsWechat ? "openid" : "uid",
            "bind_id": mBindId
            ]
        
        if mIsWechat {
            bind_account["code"] = mCode
        } else {
            bind_account["access_token"] = mAccessToken
        }
        
        // 登录参数
        let params = [
            "mobile": phoneNumber!,
            "sms_code": code,
            "client_type": "IOS",
            "client_id": client_id,
            "bind_account": bind_account
        ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_Login, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                UserDefaults.standard.set(true, forKey: Key_ISLogined)
                UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                UserInfo.current.initWith(json: result["rsp_content"])
                
                self?.showSuccess(with: "登录成功")
                self?.pushVC(PerfectUserInfoViewController())
                return
                
                if let name = UserInfo.current.nickname {
                    if name.isBlank {
                        self?.pushVC(PerfectUserInfoViewController())
                    } else {
                        self?.showSuccess(with: "登录成功")
                        self?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self?.pushVC(PerfectUserInfoViewController())
                }
            } else {
                self?.showError(with: result["sub_msg"].stringValue)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
