//
//  MineViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/16.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SwiftyJSON

class MineViewController: UIViewController, UIActionSheetDelegate {

    var mAvatorBtn: UIButton?
    var mNikeNameLable: UILabel?
    var mScoresLabel: UILabel?
    
    
    
    //    如果用户没有登录 则不创建
    var tableView : UITableView?
    let loginViewHeight :CGFloat = 150
    lazy var shareView : ShareThirdPartyView = {
        let shareView = ShareThirdPartyView.init(frame: CGRect(x: 0, y: 0, w: kScreenWidth, h: kScreenHeight))
        shareView.backgroundColor = UIColor(gray: 1.0, alpha: 0.5)
        self.view.addSubview(shareView)
        shareView.isHidden = true
        return shareView
    }()

    lazy var loginView : UIView = {
        let loginView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: loginViewHeight))
        self.view.addSubview(loginView)
        loginView.backgroundColor = .backgroundColor
        
        let loginBtn = UIButton(title: "登录", titleColor: UIColor.white, img: nil, selectedImg: nil, fontSize: 15, bgColor: UIColor.mainColor, target: self, action: #selector(loginBtnClick))
        loginView.addSubview(loginBtn!)
        loginBtn?.layer.cornerRadius = 5
        loginBtn?.layer.masksToBounds = true
        loginBtn?.snp.makeConstraints({(make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.center.equalToSuperview()
        })
        return loginView
    }()
    
    lazy var logonView : UIView = {
        let logonView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: loginViewHeight))
        self.view.addSubview(logonView)
        logonView.backgroundColor = .backgroundColor
        /// 头像
        let avatarBtn = UIButton()
        mAvatorBtn = avatarBtn
        logonView.addSubview(avatarBtn)
        avatarBtn.addTarget(self, action: #selector(avatarBtnClick), for: .touchUpInside)
        avatarBtn.setBackgroundImage(UIImage(named: "DefaultHeader"), for: .normal)
        avatarBtn.setBackgroundImageWith(URL(string: UserInfo.current.avatar ?? ""), for: .normal, placeholder: .defaultHeader)
        avatarBtn.layer.masksToBounds = true
        let avatarBtnWH :CGFloat = 80.0
        avatarBtn.layer.cornerRadius = avatarBtnWH * 0.5
        avatarBtn.snp.makeConstraints({(make) in
            make.width.height.equalTo(avatarBtnWH)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        })
        /// 昵称
        let nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nickNameLabel.text = (UserInfo.current.nickname?.length)! < 1 ? "" : UserInfo.current.nickname
        nickNameLabel.textColor = UIColor.darkGray
        logonView.addSubview(nickNameLabel)
        mNikeNameLable = nickNameLabel
        nickNameLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(180)
            make.height.equalTo(30)
            make.left.equalTo(avatarBtn.snp.right).offset(kMargin)
            make.top.equalTo(avatarBtn.snp.top).offset(kMargin)
        })
        /// 积分
        let scoreLabel = UILabel(withText: "0积分", fontSize: 12, color: .lightGray, numberOfLines: 1)
        logonView.addSubview(scoreLabel!)
        scoreLabel?.text = (UserInfo.current.points?.toString)! + "积分"
        scoreLabel?.sizeToFit()
        mScoresLabel = scoreLabel
        scoreLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(20)
            make.left.equalTo(avatarBtn.snp.right).offset(kMargin)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(0)
        })
        
        /// 向右箭头
        let arrowBtn = UIButton(title: "", titleColor: UIColor.white, img: "aui-icon-right", selectedImg: "aui-icon-right", fontSize: 1, bgColor: UIColor.clear, target: self, action: #selector(arrowBtnClick))
        logonView.addSubview(arrowBtn!)
        arrowBtn?.snp.makeConstraints({(make) in
            make.width.equalTo(34)
            make.centerY.right.equalToSuperview()
            make.height.equalTo(34)
        })
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .backgroundColor
        logonView.addSubview(seperatorView)
        seperatorView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kMargin)
        })
        
        logonView.isUserInteractionEnabled = true
        logonView.addTapGesture(action: { [weak self](tap) in
            self?.arrowBtnClick()
        })
        
        return logonView
    }()
    
    lazy var logoutButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(logoutButtonClick), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49)
        })
        btn.isHidden = true
        return btn
    }()
    
    let datas : [String] = ["我的收藏","我的通知","分享应用给好友","关于我们","版本号"]
    var userLogin : Bool = false {
        didSet {
            if userLogin {
                self.getUserInfo()
            }
            self.logoutButton.isHidden = !userLogin
            tableView?.tableHeaderView = userLogin ? logonView : loginView
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userLogin = UserDefaults.standard.bool(forKey: Key_ISLogined)
        AssistiveBtn.shared.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        self.view.backgroundColor = .backgroundColor
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        userLogin = UserDefaults.standard.bool(forKey: Key_ISLogined)
        self.shareView.shareWechatBtn?.addTarget(self, action: #selector(shareWechatBtnClick), for: .touchUpInside)
        self.shareView.shareFriendsBtn?.addTarget(self, action: #selector(shareFriendsBtnClick), for: .touchUpInside)
        self.shareView.shareWeiboBtn?.addTarget(self, action: #selector(shareWeiboBtnClick), for: .touchUpInside)
        self.shareView.cancelBtn?.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
    }

    //MARK: - 分享
   @objc func shareWechatBtnClick() {
        guard isLogined() else {
            return
        }
    
        wechatShare(url: AppInfo.shared.app_download_url ?? "", image: UIImage(named: kShareAppImageName)!, title: kShareAppTitle, description: kShareAppDes, to: .Session)
    }
    
   @objc func shareFriendsBtnClick() {
        guard isLogined() else {
            return
        }
    
        wechatShare(url: AppInfo.shared.app_download_url ?? "", image: UIImage(named: kShareAppImageName)!, title: kShareAppTitle, description: kShareAppDes, to: .Timeline)
    }
    
   @objc func shareWeiboBtnClick() {
        guard isLogined() else {
            return
        }
    
        weiboShare(url: AppInfo.shared.app_download_url ?? "", image: UIImage(named: "IMG_WeiBoShareImg"), title: kShareAppTitle, description: kShareAppDes)
    }
    
   @objc func cancelBtnClick() {
       AssistiveBtn.shared.isHidden = false
        self.shareView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.cancelBtnClick()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .backgroundColor
        tableView?.register(MineTableViewCell.self, forCellReuseIdentifier: "MineTableViewCell")
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        
    }
    
    //MARK: -按钮点击事件
    @objc func loginBtnClick(){
        AssistiveBtn.shared.removeFromSuperview()
        present(UINavigationController(rootViewController: LoginViewController()), animated: true)
    }
     /// 头像被点击
    @objc func avatarBtnClick(){
        arrowBtnClick()
    }
    /// 向右箭头被点击
    @objc func arrowBtnClick(){
        let vc = UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "MineDetailViewController") as? MineDetailViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    /// 退出登录按钮被点击
    @objc func logoutButtonClick(){
        
        let alertController = UIAlertController(title: "系统提示",message: "您确定要离开退出登录吗？", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "退出", style: .default, handler: { [weak self]
            action in
            self?.logoutRequest()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logoutRequest() {
        RequestManager.shared.Post(URLString: URL_Logout) { [weak self] (resultValue) in
            UserDefaults.standard.set(false, forKey: Key_ISLogined)
            self?.userLogin = false
            UserInfo.current.removeUser()
        }
    }
    
    func getUserInfo() {
        let params: [String: Any] = [:]
        RequestManager.shared.Post(URLString: URL_UserInfo, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 更新用户信息
                UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                UserInfo.current.initWith(json: result["rsp_content"])
                self?.mAvatorBtn?.setImage(with: URL(string: UserInfo.current.avatar ?? ""), placeHolder: .defaultHeader, completionHandler: { (image, error, type, url) in
                    self?.mAvatorBtn?.setImage(image?.scaled(to: CGSize(width: 200, height: 200)), for: .normal)
                })
                
                self?.mNikeNameLable?.text = UserInfo.current.nickname
                self?.mScoresLabel?.text = (UserInfo.current.points ?? 0).toString + "积分"
                // 刷新红点
                self?.tableView?.reloadData()
            }
        }
    }
}

extension MineViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineTableViewCell", for: indexPath) as? MineTableViewCell
        cell?.nameLabel?.text = self.datas[indexPath.row]
        ///  有通知来的时候 有红点
        if indexPath.row == 1 && UserInfo.current.new_comment != 0 {
            cell?.redDotView?.isHidden = false
        }else{
            cell?.redDotView?.isHidden = true
        }
        
        // 版本号
        if indexPath.row == 4 {
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            cell?.nameLabel?.text = datas[indexPath.row] + ": \(version)"
            cell?.mAccessoryView?.isHidden = true
        }
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        /// 我的收藏
        if indexPath.row == 0 {
            guard UserDefaults.standard.bool(forKey: Key_ISLogined) else {
                AssistiveBtn.shared.removeFromSuperview()
                present(UINavigationController(rootViewController: LoginViewController()), animated: true)
                return
            }

            let vc = MyStoreViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

        /// 我的通知
        else if indexPath.row == 1 {

            guard UserDefaults.standard.bool(forKey: Key_ISLogined) else {
                AssistiveBtn.shared.removeFromSuperview()
                present(UINavigationController(rootViewController: LoginViewController()), animated: true)
                return
            }

            let vc = MyNoticeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

        /// 我的分享
        else if indexPath.row == 2 {
    
            guard UserDefaults.standard.bool(forKey: Key_ISLogined) else {
                AssistiveBtn.shared.removeFromSuperview()
                present(UINavigationController(rootViewController: LoginViewController()), animated: true)
                return
            }
            
            AssistiveBtn.shared.isHidden = true
            self.shareView.isHidden = false
        }
        
        else if indexPath.row == 3 {
            let vc = AboutUsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 版本号
        else if indexPath.row == 4 {
            
        }
        
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.cancelBtnClick()
    }
}
