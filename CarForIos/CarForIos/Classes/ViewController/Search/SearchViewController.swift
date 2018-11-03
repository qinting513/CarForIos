//
//  SearchViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/16.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import SwiftRichString

class SearchViewController: UIViewController {
    
    var mIsSelected: Bool = false

    var mSearchInput: SearchInputView?

    var datas = [HomeModel]()
    
    // tableView
    lazy var tableView: UITableView = { 
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .backgroundColor
        // 注册cellID
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        tableView.register(CommonNoDataCell.self, forCellReuseIdentifier: CommonNoDataCell.className())
        tableView.register(LContentRImageCell.self, forCellReuseIdentifier: LContentRImageCell.className())
        tableView.register(ItemsCell.self, forCellReuseIdentifier: ItemsCell.className())
        return tableView
        }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navBar?.isHidden = true
        hidesBottomBarWhenPushed = true
        AssistiveBtn.shared.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navBar?.isHidden = false
        hidesBottomBarWhenPushed = false
        AssistiveBtn.shared.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜索"
        automaticallyAdjustsScrollViewInsets = true
        navBar?.isHidden = true
        view.backgroundColor = .backgroundColor
        setupUI()
    }
    
    func setupUI(){
        hidesBottomBarWhenPushed = true
        
        let inputHeader = SearchInputView(frame: .zero)
        inputHeader.mSearchInputTextField?.delegate = self
        view.addSubview(inputHeader)
        inputHeader.mSearchBtn?.addTarget(self, action: #selector(searchBtnDidClick), for: .touchUpInside)
        inputHeader.mBackBtn?.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        inputHeader.mSearchInputTextField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        inputHeader.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavBarHeight)
        }
        mSearchInput = inputHeader
        
        // 添加tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(inputHeader.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 搜索按钮点击事件
    @objc func searchBtnDidClick(btn: UIButton) {
        if let searchValue = mSearchInput?.mSearchInputTextField?.text {
            if searchValue.length > 0 {
                searchData(with: searchValue)
            } else {
                
                popVC()
            }
            return
        }
        
        popVC()
    }
    
    /// 返回按钮点击事件
    @objc func backBtnDidClick(btn: UIButton) {
        view.endEditing(true)
        popVC()
    }
}

extension SearchViewController:UITableViewDataSource,UITableViewDelegate {
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count == 0 ? 1 : datas.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if datas.count == 0 {
            let cell: CommonNoDataCell = CommonNoDataCell(style: .default, reuseIdentifier: CommonNoDataCell.className())
            cell.mDesLabel?.text = "暂无相关内容"
            return cell
        }
        
        let model = datas[indexPath.row]
        
        if model.push_app_type == .group {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemsCell.className(), for: indexPath) as? ItemsCell
            cell?.articles = model.articles
            cell?.mDelegate = self
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LContentRImageCell.className(), for: indexPath) as? BaseHomeCell
        cell?.setupModel(model: model, indexPathRow:indexPath.row,isKnow: true)
        //  点赞跟收藏按钮
        cell?.homeDelegate = self
        return cell ?? UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datas.count == 0 {
            return 300
        }
        
        let model = datas[indexPath.row]
        if model.push_app_type == .group {
            return  kMargin*3 + kFavoriteBtnHeight + 110 + 130
        } else {
            return kSmallImgHeight + kMarginTop + -kMarginBottm - 9
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if datas.count > 0 {
            return 20
        }
        return 0
    }
    
    //MARK: 点击cell
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        
        if datas.count == 0 {
            return
        }
        
        showLoading()
        if mIsSelected {
            delay(2) {[weak self] in
                self?.mIsSelected = false
            }
            return
        }
        
        let model = datas[indexPath.row]
        RequestManager.shared.articleDetailRequest(articleID: model.id ?? "") { [weak self](vc) in
            self?.pushVC(vc)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }

    //MARK: 点赞按钮点击事件 isKnow在这里没有用
    
    //MARK:收藏按钮点击
    func homeCellFavoriteBtnClick(indexPathRow : Int, isKnow:Bool?){
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SearchViewController {
    func searchData(with searchValue: String) {
        mSearchInput?.mSearchInputTextField?.resignFirstResponder()
        
        let params = [
            "client_type": "APP",
            "title": searchValue,
            "page_index": 1,
            "page_size": 50,
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_ArticleList, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let HomeModels = [HomeModel].deserialize(from: toJSONString(arr: itemArr!)) {
                    self?.datas = HomeModels as! [HomeModel]
                    self?.tableView.reloadData()
                }
            }

        }
    }
}

extension SearchViewController: ItemCellCollectionItemDidSelected{
    func collectionItemClick(article: HomeModel?) {
        RequestManager.shared.articleDetailRequest(articleID: article?.id ?? "") { [weak self](vc) in
            self?.pushVC(vc)
        }
    }
}

extension SearchViewController: BaseHomeCellDelegate {

    func homeCellLikeBtnClick(indexPathRow: Int, isKnow: Bool?, sender: UIButton) {
        
    }
    
    func homeCellFavoriteBtnClick(indexPathRow: Int, isKnow: Bool?, sender: UIButton) {
        let model = datas[indexPathRow]
        guard isLogined() else {
            sender.isSelected = false
            return
        }
        RequestManager.shared.favoriteArticleRequest(articleId: model.id ?? "", commintId: nil, isLike: model.like == 0) {[weak self] (success) in
            if success {
                if model.like == 0 {
                    model.like = 1
                    model.like_count += 1
                    self?.showSuccess(with: "谢谢您的点赞！✌️")
                    sender.isSelected = true
                    sender.setTitle(model.like_count.toString, for: .normal)
                } else {
                    model.like = 0
                    model.like_count -= 1
                    self?.showSuccess(with: "取消点赞成功 ")
                    sender.isSelected = false
                    sender.setTitle(model.like_count.toString, for: .normal)
                }
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    @objc func textDidChange(textField: UITextField) {
        if let textString = textField.text {
            if textString.length > 0 {
                UIView.animate(withDuration: 0.5) {
                    self.mSearchInput?.mSearchBtn?.isSelected = true
                    self.mSearchInput?.mBackBtn?.snp.updateConstraints({ (make) in
                        make.width.equalTo(25)
                    })
                    self.mSearchInput?.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.mSearchInput?.mSearchBtn?.isSelected = false
                    self.mSearchInput?.mBackBtn?.snp.updateConstraints({ (make) in
                        make.width.equalTo(00)
                    })
                    self.mSearchInput?.layoutIfNeeded()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ : UITextField) -> Bool {
        if let searchValue = mSearchInput?.mSearchInputTextField?.text {
            if searchValue.length > 0 {
                searchData(with: searchValue)
            }
        }
        return false
    }
}


class SearchInputView: UIView {
    
    var mSearchIcon: UIImageView?
    
    var mSearchInputTextField: UITextField?
    
    var mSearchBtn: UIButton?
    
    var mBackBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "IMG_Back"), for: .normal)
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.width.equalTo(0)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-12)
        }
        mBackBtn = backButton
        
        let searchIcon = UIImageView(image: UIImage(named: "IMG_Search_Icon"))
        addSubview(searchIcon)
        searchIcon.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        let textField = UITextField()
        textField.placeholder = "请输入您关心的内容"
        textField.textColor = HexString(hex: "999999")
        textField.font = SystemFonts.PingFangSC_Regular.font(size: 16)
        textField.textAlignment = .left
        textField.returnKeyType = .send
        textField.backgroundColor = .white
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon.snp.right).offset(10)
            make.right.equalToSuperview().offset(-70)
            make.bottom.equalToSuperview().offset(-7)
            make.height.equalTo(30)
        }
        mSearchInputTextField = textField
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("搜索", for: .selected)
        cancelBtn.isSelected = false
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(HexString(hex: "999999"), for: .normal)
        cancelBtn.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 14)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-7)
        }
        mSearchBtn = cancelBtn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
