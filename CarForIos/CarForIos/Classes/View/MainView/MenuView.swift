//
//  MenuView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/15.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString

class MenuView: UIView {

    var tableView : UITableView?
    var searchBtn : UIButton?
    var menuViewSelectClosure : ((_ index:Int)->())?
    let datas = ["首页","顽车","顽技","我的","关于我们"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
//        alpha = 0.99
        
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .extraLight)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame.size = CGSize(width: frame.width, height: frame.height)
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        addSubview(blurView)
//        addSubview(blurView)
//        addSubview(blurView)

        var marginTop = kMargin * 2
        if UIScreen.main.bounds.height == 812 {
            marginTop = kMargin * 2 + 24
        }
        
        let searchView = UIView(frame: CGRect(x: 15, y: marginTop, w: kScreenWidth-30, h: 44))
        searchView.backgroundColor = .white
        searchView.layer.cornerRadius = 5
        searchView.layer.masksToBounds = true
        addSubview(searchView)
        
        let searchIcon = UIImageView(image: UIImage(named: "IMG_Search_Icon"))
        searchIcon.frame = CGRect(x: 15, y: 11, w: 20, h: 20)
        searchView.backgroundColor = .white
        searchView.addSubview(searchIcon)

        let label = UILabel(frame: CGRect(x: 55, y: 0, width: kScreenWidth-79, height: 44))
        label.text = "请输入您关心的内容"
        label.textColor = HexString(hex: "999999")
        label.font = SystemFonts.PingFangSC_Regular.font(size: 15)
        label.textAlignment = .left
        label.backgroundColor = .white
        searchView.addSubview(label)
        
        searchBtn = UIButton(frame: label.frame)
        searchView.addSubview(searchBtn!)
        searchBtn?.setBackgroundColor(.clear, forState: .normal)
        searchBtn?.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 150, width: kScreenWidth, height: kScreenHeight - 150), style: .plain)
        self.addSubview(tableView!)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.tableFooterView = UIView()
        tableView?.separatorStyle = .none
        tableView?.isScrollEnabled = false
        tableView?.backgroundColor = .clear
        tableView?.register(MenuViewCell.self, forCellReuseIdentifier: "MenuViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name(kReloadMenuTableView), object: nil)
    }
    
    @objc func reloadTableView() {
        tableView?.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func searchBtnClick(){
        self.removeFromSuperview()
        AssistiveBtn.shared.isSelected = false
        let vc = SearchViewController()
        let rootVc = UIApplication.shared.keyWindow?.rootViewController as? HomeNavigationController
        rootVc?.pushViewController(vc, animated: true)
        
    }
    
}

extension MenuView : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuViewCell", for: indexPath) as! MenuViewCell
        cell.mTitleLable?.text = self.datas[indexPath.row]
        
        // 我的
        if indexPath.row == 3 {
            cell.mNewMsgView?.isHidden = UserInfo.current.new_comment! < 1
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        if let block = self.menuViewSelectClosure {
            block(indexPath.row)
        }
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}

