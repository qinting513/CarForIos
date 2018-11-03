//
//  ChangeNameViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangeNameViewController: UITableViewController {

    lazy var footerView : UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 120))
        self.view.addSubview(footerView)
        footerView.backgroundColor = .backgroundColor
        
        let saveBtn = UIButton(title: "保存", titleColor: .white, img: nil, selectedImg: nil, fontSize: 15, bgColor: .lightGray, target: self, action: #selector(saveBtnClick))
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
    
    @IBOutlet weak var inputTextField: UITextField!
   
    var saveButton : UIButton?
    var changeNameCallBack : ( (_ name:String)->() )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改名字"
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .backgroundColor
        tableView.tableFooterView = footerView
        tableView.rowHeight = 50
        inputTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }

    @objc func saveBtnClick(){
        let text = inputTextField.text?.trimmed()
        if text?.length == 0 {
            self.view.showError(with: "请输入合法的名字")
            return
        }
       if let block = changeNameCallBack {
    
           let params = [ "nickname" : text! ]
            RequestManager.shared.Post(URLString: URL_Update, parameters: params) { [weak self] (resultValue) in
                let result = JSON(resultValue)
                if result["sub_code"].stringValue == "SUCCESS" {
                    block(text ?? "")
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.view.showError(with: "修改名字失败")
                }
            }
        }
    }
    @objc func textChange(_ textField: UITextField){
        let text = textField.text?.trimmed()
        if (text?.length ?? 0) > 0 {
            self.saveButton?.backgroundColor = .mainColor
            self.saveButton?.isUserInteractionEnabled = true
        }else{
            self.saveButton?.backgroundColor = .lightGray
            self.saveButton?.isUserInteractionEnabled = false
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
