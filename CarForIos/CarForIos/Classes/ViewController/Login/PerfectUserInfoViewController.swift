//
//  PerfectUserInfoViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/9/4.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON

class PerfectUserInfoViewController: UIViewController {

    var mInputTextField: UITextField?
    
    var mHintLabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "完善信息"
        view.backgroundColor = .white
        
        let titlelabel = UILabel()
        view.addSubview(titlelabel)
        titlelabel.text = "用户昵称"
        titlelabel.textColor = RGB(r: 121, g: 121, b: 121)
        titlelabel.font = UIFont.systemFont(ofSize: 16)
        titlelabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalToSuperview().offset(kMarginTop+kNavBarHeight)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        let inputTextField = UITextField()
        view.addSubview(inputTextField)
        inputTextField.text = UserInfo.current.nickname
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputTextField.snp.makeConstraints { (make) in
            make.left.equalTo(titlelabel.snp.right)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalToSuperview().offset(kMarginTop+kNavBarHeight)
            make.height.equalTo(44)
        }
        mInputTextField = inputTextField
        
        let bottomLine = UIView()
        view.addSubview(bottomLine)
        bottomLine.backgroundColor = .lightGray
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let hintLabel = UILabel()
        hintLabel.textColor = .red
        hintLabel.text = "*用户昵称不能为空"
        hintLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titlelabel.snp.left)
            make.top.equalTo(inputTextField.snp.bottom).offset(5)
            make.width.greaterThanOrEqualTo(80)
            make.height.equalTo(22)
        }
        mHintLabel = hintLabel
        
        let doneBtn = UIButton()
        doneBtn.setCornerRadius(radius: 22)
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.setTitleColor(.white, for: .normal)  // 234    165    84
        doneBtn.setBackgroundColor(RGB(r: 234, g: 165, b: 84), forState: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnDidClick), for: .touchUpInside)
        view.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(hintLabel.snp.bottom).offset(kMarginTop)
            make.height.equalTo(44)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let value = textField.text?.trimmed() {
            mHintLabel?.isHidden = value.length > 0
        }
    }
    
    @objc func doneBtnDidClick() {
        
        let text = mInputTextField?.text?.trimmed()
        if text?.length == 0 {
            self.view.showError(with: "请输入合法的名字")
            return
        }

        let params = [ "nickname" : text! ]
        RequestManager.shared.Post(URLString: URL_Update, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.view.showError(with: "修改名字失败")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
