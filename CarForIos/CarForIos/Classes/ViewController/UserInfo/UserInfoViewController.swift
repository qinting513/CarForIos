//
//  UserInfoViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SwiftyJSON
import SnapKit

let iconWH : CGFloat = 50.0
let desFont: CGFloat = 12.0

class UserInfoViewController: UIViewController {

    var datas = [HomeModel]()
    ///  作者头像
    var avatarImageView : UIImageView?
    var nickNameLabel : UILabel?
    // 签名
    var signLabel: UILabel?
    // 文章模型
    var article: ActicleModel?
    
    var mAuthor: AuthorInfo? {
        didSet {
            avatarImageView?.setImage(with: URL(string: (mAuthor?.user_avatar)!), placeHolder: .defaultHeader)
            nickNameLabel?.text = (mAuthor?.user_name?.length)! < 1 ? "" : mAuthor?.user_name
            signLabel?.text = mAuthor?.user_desc
            let height: CGFloat = getTextHeigh(textStr: (signLabel?.text)!, font: desFont, width: kScreenWidth - iconWH - 30 - 15)
            signLabel?.snp.updateConstraints({ (make) in
                make.height.equalTo(height+10)
            })
            var frame = userInfoView.frame
            frame.size.height = 50 + height
            userInfoView.frame = frame
        }
    }
    
    let userInfoViewHeight :CGFloat = 170
    ///
    lazy var userInfoView : UIView = {
        let userInfoView = UIView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: userInfoViewHeight))
        self.view.addSubview(userInfoView)
        userInfoView.backgroundColor = .backgroundColor
        /// 头像
        avatarImageView = UIImageView(image: .defaultHeader)
        userInfoView.addSubview(avatarImageView!)
        avatarImageView?.setCornerRadius(radius: iconWH*0.5)
        avatarImageView?.snp.makeConstraints({(make) in
            make.width.height.equalTo(iconWH)
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalToSuperview().offset(kMarginTop)
        })
        /// 昵称
        let nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nickNameLabel.text = "用户昵称"
        nickNameLabel.textColor = .darkGray
        userInfoView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(180)
            make.height.equalTo(25)
            make.left.equalTo(avatarImageView?.snp.right ?? 0).offset(kMargin)
            make.top.equalTo(avatarImageView?.snp.top ?? 0)
        })
        self.nickNameLabel = nickNameLabel
        
        /// 签名
        let scoreLabel = UILabel(withText: "这人很懒，什么都没写", fontSize: desFont, color: HexString(hex: "999999"), numberOfLines: 0)
        userInfoView.addSubview(scoreLabel!)
        scoreLabel?.sizeToFit()
        scoreLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(45)
            make.width.equalTo(kScreenWidth - iconWH - 30 - 15)
            make.left.equalTo(avatarImageView?.snp.right ?? 0).offset(kMargin)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(0)
        })
        self.signLabel = scoreLabel
        return userInfoView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .backgroundColor
        // 注册cellID
        tableView.register(LImageRContentCell.self, forCellReuseIdentifier: "LContentRImageCell")
        tableView.tableHeaderView = self.userInfoView
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (article?.user_id?.length)! > 0 {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "作者信息"
        self.view.addSubview(tableView)
    }

    func loadData(){
        let params = [
            "client_type": "APP",
            "module": "",
            "classify": "",
            "user_id": article?.user_id ?? "",
            "scope": "AUTO",
            "push_module": "",
            "push_classify": "",
            "push_type": "",
            "page_index": 1,
            "page_size": 50,
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_ArticleList, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let authorDic = result["rsp_content"]["author"].dictionaryObject
                if let author = AuthorInfo.deserialize(from: toJSONString(dict: authorDic)) {
                   self?.mAuthor = author
                }
                
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let HomeModels = [HomeModel].deserialize(from: toJSONString(arr: itemArr!)) {
                   let dataArr = HomeModels as! [HomeModel]
                    // TODO: 先去除group类型的cell  后期再处理
                    self?.datas = dataArr.filter({ $0.push_app_type != .group })
                    self?.tableView.reloadData()
                }
            }
            
        }
        
    }
    

}

extension UserInfoViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LContentRImageCell", for: indexPath) as? BaseHomeCell
        cell?.setupModel(model: model, indexPathRow:indexPath.row,isKnow: true)
        //  点赞跟收藏按钮
        cell?.homeDelegate = self as? BaseHomeCellDelegate
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kSmallImgHeight + kMarginTop + -kMarginBottm - 9
    }
    
    //MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        pushDetail(with: datas[indexPath.row])
    }
}
