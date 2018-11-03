
//
//  ChangePhoneViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangePhoneViewController: UITableViewController {
    
    // 原手机验证后的验证 ID
    var mOldMsgId: String?
    
    // 新手机验证后的验证 ID
    var mNewMsgId: String?

    lazy var footerView : UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 120))
        self.view.addSubview(footerView)
        footerView.backgroundColor = .backgroundColor
        
        let saveBtn = UIButton(title: "下一步", titleColor: .white, img: nil, selectedImg: nil, fontSize: 15, bgColor: .lightGray, target: self, action: #selector(saveBtnClick))
        saveBtn?.setTitleColor(.white, for: .normal)
        saveBtn?.isUserInteractionEnabled = false
        footerView.addSubview(saveBtn!)
        saveBtn?.snp.makeConstraints({(make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        })
        self.saveButton = saveBtn
        return footerView
    }()
    
    var saveButton : UIButton?
    var changeNameCallBack : ( (_ name:String)->() )?
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var sendCodeBtn: UIButton!
    // 获取验证码
    @IBAction func sendCodeButtonClick(_ sender: UIButton) {
        let phoneNumber = phoneTextField.text!
        let isPhone: Bool = isPhoneNumber(phoneNumber)
        if !isPhone {
            self.showError(with: "请输入正确的手机号码")
            return
        }
        
        // 倒计时60秒
        sender.countDown(count: 60)
    
        let params = [
            "type": "change_mobile",
            "mobile": phoneTextField.text!,
            ]
        
        RequestManager.shared.Post(URLString: URL_SmsCode, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "验证码发送成功！")
            } else {
                self?.view.showError(with: result["msg"].stringValue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .backgroundColor
        tableView.tableFooterView = footerView
        tableView.rowHeight = 50
        
        phoneTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        codeTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    @objc func saveBtnClick(){
        
        let phone = phoneTextField.text
        let isPhone: Bool = isPhoneNumber(phone ?? "")
        if !isPhone {
            self.showError(with: "请输入正确的手机号码")
            return
        }
        
        let code = codeTextField.text
        if (code?.length)! < 1 {
            showError(with: "请输入要验证码")
            return
        }
        
        let params = [
            "new_mobile": phone!,
            "sms_code": code!,
            "sms_id": mOldMsgId ?? ""
            ] as [String: Any]
        
        RequestManager.shared.Post(URLString: URL_ChangeMobile, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "更改手机号成功")
                for vc in (self?.navigationController?.childViewControllers)! {
                    if vc is MineViewController {
                        self?.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            } else {
                self?.view.showError(with: "新手机验证失败")
            }
        }
    }
    
    @objc func textChange(_ textField: UITextField){
        let t1 = phoneTextField.text?.trimmed().length
        let t2 = codeTextField.text?.trimmed().length
        if t1 == 11 && (t2 ?? 0) > 0{
            setupSaveButton(isEnabled: true)
        }else{
            setupSaveButton(isEnabled: false)
        }
    }
    
    @objc func setupSaveButton(isEnabled:Bool) {
        
        if isEnabled {
            self.saveButton?.backgroundColor = .mainColor
            self.saveButton?.isUserInteractionEnabled = true
        }else{
            self.saveButton?.backgroundColor = .lightGray
            self.saveButton?.isUserInteractionEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
