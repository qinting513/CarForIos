//
//  VerifyTellViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/8/9.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class VerifyTellViewController: UIViewController {
    
    var mOldMsgId: String?
    
    var mPhoneNumberInputView: CommonInputView?
    
    var mCodeInputView: CommonInputView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        
        setupUI()
    }
    
    func setupUI() {
        let phoneInput = CommonInputView(frame: .zero)
        view.addSubview(phoneInput)
        phoneInput.mTitleLabel?.text = "已验证手机"
        //phoneInput.mInputTextField?.text = privacyMobile(number: UserInfo.current.mobile!)
        phoneInput.mShowCodeBtn = true
        phoneInput.mCodeBtn?.addTarget(self, action: #selector(VerifyTellViewController.sendCodeBtn(sender:)), for: .touchUpInside)
        phoneInput.mInputTextField?.text = UserInfo.current.mobile!
        phoneInput.mInputTextField?.isEnabled = false
        phoneInput.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarHeight + kMarginTop)
            make.height.equalTo(40)
        }
        mPhoneNumberInputView = phoneInput
        
        let codeInput = CommonInputView(frame: .zero)
        view.addSubview(codeInput)
        codeInput.mTitleLabel?.text = "短信验证码"
        codeInput.mInputTextField?.placeholder = "请输入验证码"
        codeInput.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(phoneInput.snp.bottom).offset(kMarginTop)
            make.height.equalTo(40)
        }
        mCodeInputView = codeInput
        
        let hintLabel = UILabel()
        view.addSubview(hintLabel)
        hintLabel.text = "温馨提示: 如果您无法验证绑定手机号, 请联系客服。\n客服电话: xxxxxx"
        hintLabel.font = .subtitleFont
        hintLabel.numberOfLines = 0
        hintLabel.textColor = .red
        hintLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(codeInput.snp.bottom).offset(kMarginTop)
            make.height.equalTo(0)
        }
        
        let nextStepBtn = UIButton()
        view.addSubview(nextStepBtn)
        nextStepBtn.setTitle("下一步", for: .normal)
        nextStepBtn.setBackgroundColor(.mainColor, forState: .normal)
        nextStepBtn.layer.masksToBounds = true
        nextStepBtn.layer.cornerRadius = 5
        nextStepBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextStepBtn.setTitleColor(.white, for: .normal)
        nextStepBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(hintLabel)
            make.top.equalTo(hintLabel.snp.bottom).offset(kMarginTop)
            make.height.equalTo(40)
        }
    }
    
    @objc func sendCodeBtn(sender: UIButton) {
        sender.countDown(count: 60)
        
        let params = [
            "type": "change_mobile",
            "mobile": UserInfo.current.mobile ?? "",
        ] as [String: Any]
        
        RequestManager.shared.Post(URLString: URL_SmsCode, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "验证码发送成功！")
                let msg_id = result["rsp_content"]["msg_id"].stringValue
                self?.mOldMsgId = msg_id
            } else {
                self?.view.showError(with: result["msg"].stringValue)
            }
        }
    }

    @objc func nextStep() {
        let code = mCodeInputView?.mInputTextField?.text
        if (code?.length)! < 0 {
            showError(with: "请输入验证码")
            return
        }
        
        let params = [
            "type": "change_mobile",
            "mobile": UserInfo.current.mobile ?? "",
            "sms_code": code!
        ] as [String: Any]
        
        RequestManager.shared.Post(URLString: URL_MsgVerify, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "校验成功")
                let msg_id = result["rsp_content"]["msg_id"].stringValue
                let vc = UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "ChangePhoneViewController") as? ChangePhoneViewController
                vc?.mOldMsgId = msg_id
                self?.pushVC(vc!)
            } else {
                self?.view.showError(with: "短信验证失败")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func privacyMobile(number: String) -> String {
        
        guard isPhoneNumber(number) else {
            return ""
        }
        
        let firstValue = number.substring(from: 0, length: 3)
        let endValue = number.substring(from: 7, length: 4)
        return firstValue! + "****" + endValue!
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
