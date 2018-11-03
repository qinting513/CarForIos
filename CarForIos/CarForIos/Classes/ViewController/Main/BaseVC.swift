//
//  BaseVC.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/11.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import SwiftRichString

enum CellType : Int {
    case LeftImgRightContent = 1
    case LeftContentRightImg = 2
    case TopImgBottomContent = 3
    case Items               = 4
}

class BaseVC:  UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    var segmentBar : SegmentBar?
    /// 大的背景ScrollView 用于滚动的
    var bgScrollView : UIScrollView?
    
    // MARK - HOME -
    /// 知
    var knowTableView : UITableView?
    /// 轮播图
    var knowTableViewScrollView : ScrollView?
    /// 解
    var answerTableView : UITableView?
    /// 记录当前是 知 还是 解
    var currentIndex :Int = 0
    
    ///知 数据源
    var knowDatas = [HomeModel]() {
        didSet {
            var type: Push_App_Type = .leftImg
            knowDatas.forEachEnumerated { (index, model) in
                
                /// 第一个就是大图, 不显示顶部图片
                if index == 0 && model.push_app_type == .bigImg {
                    model.hidenBigImgTopLine = true
                }
                
                if type == model.push_app_type {
                    model.showLine = true
                }
                
                /// 大图与左图右图之间不隐藏线条
                else if type == .bigImg && (model.push_app_type == .rightImg || model.push_app_type == .leftImg) {
                    model.showLine = true
                    type = model.push_app_type ?? .rightImg
                }
                
                else {
                    model.showLine = false
                    type = model.push_app_type ?? .rightImg
                }
            }
            knowTableView?.reloadData()
        }
    }
    /// 解 数据源
    var answerDatas = [HomeModel]() {
        didSet {
            var type: Push_App_Type = .leftImg
            answerDatas.forEachEnumerated { (index, model) in
                
                /// 第一个就是大图, 不显示顶部图片
                if index == 0 && model.push_app_type == .bigImg {
                    model.hidenBigImgTopLine = true
                }
                
                
                if type == model.push_app_type {
                    model.showLine = true
                }
                
                /// 大图与左图右图之间不隐藏线条
                else if type == .bigImg && (model.push_app_type == .rightImg || model.push_app_type == .leftImg) {
                    model.showLine = true
                    type = model.push_app_type ?? .rightImg
                }
                
                else {
                    model.showLine = false
                    type = model.push_app_type ?? .rightImg
                }
            }
            answerTableView?.reloadData()
        }
    }
    
    var mKnowPageIndex: Int = 1
    
    var mAnswerPageIndex: Int = 1
    
    var mIsSelected: Bool = false
    
    // 福袋视图
    lazy var mLuckyBagView : LuckyBagView = {
        let view = LuckyBagView(frame: CGRect(x: 0, y: 0, w: kScreenWidth, h: kScreenHeight))
        //view.mBackgroundImageView?.addTapGesture(target: self, action: #selector(hidenLuckBag))
        view.mAddButton?.addTarget(self, action: #selector(luckyBagBtn), for: .touchUpInside)
        return view
    }()
    
    @objc func hidenLuckBag() {
        mLuckyBagView.removeFromSuperview()
        AssistiveBtn.shared.isHidden = false
    }
    
    @objc func luckyBagBtn() {
        let params = [
            "type": "D_LUCKY_BAG"
        ]
        RequestManager.shared.Post(URLString: URL_PointsTake, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.mLuckyBagView.removeFromSuperview()
                AssistiveBtn.shared.isHidden = false
                self?.showSuccess(with: "获取积分成功 ✌️")
            } else {
                self?.mLuckyBagView.removeFromSuperview()
                AssistiveBtn.shared.isHidden = false
                self?.showError(with: result["msg"].stringValue)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        
        AssistiveBtn.shared.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    
    
    //MARK: -    重写title  的 setter方法
    override var title: String? {
        didSet{
            let titleLabel = UILabel(x: 0, y: 0, w: 200, h: 44)
            let titleStyle = Style {
                $0.font = SystemFonts.PingFangSC_Semibold.font(size: 20)
                $0.color = UIColor.black
            }
            let myGroup = StyleGroup(["title": titleStyle])
            
            // Use tags in your plain string
            let str = "<title>\(title ?? "")</title>"
            titleLabel.textAlignment = .center
            titleLabel.attributedText =  str.set(style: myGroup)
            navigationItem.titleView = titleLabel
        }
    }
    
    @objc func loadData() {
        // 如果不实现任何方法，则默认关闭
         knowTableView?.endHeaderRefresh()
         answerTableView?.endHeaderRefresh()
    }
    
    
    @objc func headerRefresh() {
        // 如果不实现任何方法，则默认关闭
        knowTableView?.endHeaderRefresh()
        answerTableView?.endHeaderRefresh()
    }
    
    
    @objc func footerRefresh() {
        // 如果不实现任何方法，则默认关闭
        knowTableView?.endHeaderRefresh()
        answerTableView?.endHeaderRefresh()
    }
    
    func endRefresh() {
        knowTableView?.endHeaderRefresh()
        knowTableView?.endFooterRefresh()
        answerTableView?.endHeaderRefresh()
        answerTableView?.endFooterRefresh()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}

//设置界面
extension BaseVC {
    
    private  func setupUI() {
        view.backgroundColor = UIColor.white
         setupSegmentBar()
         setupBgScrollView()
    }
    
    func setupSegmentBar(){
        segmentBar = SegmentBar(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kSegmentBarHeight))
        segmentBar?.backgroundColor = .white
        view.addSubview(segmentBar!)
        segmentBar?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavBarHeight)
            make.height.equalTo(kSegmentBarHeight)
        })
        segmentBar?.segmentButtonClickCallBack = { [weak self] (index) in
            
            print(NSStringFromCGRect((self?.bgScrollView?.frame)!))
            print(NSStringFromCGRect((self?.answerTableView?.frame)!))
            print(NSStringFromCGRect((self?.knowTableView?.frame)!))
            
            self?.currentIndex = index
            self?.bgScrollView?.setContentOffset(CGPoint(x: kScreenWidth * CGFloat(index), y: 0), animated: true)
        }
    }
    func setupBgScrollView(){
        //        取消自动缩进 如果隐藏了导航栏会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        bgScrollView = UIScrollView(frame: CGRect(x: 0, y: kNavBarHeight+kSegmentBarHeight, width: kScreenWidth, height: kScreenHeight - kNavBarHeight))
        bgScrollView?.showsHorizontalScrollIndicator = false
        bgScrollView?.showsVerticalScrollIndicator = false
        bgScrollView?.contentSize = CGSize(width: kScreenWidth * 2, height: (bgScrollView?.frame.size.height ?? 0))
        bgScrollView?.isPagingEnabled = true
        bgScrollView?.bounces = false
        bgScrollView?.delegate = self
        self.view.addSubview(bgScrollView!)
        
        setupKnowTableView()
        setupAnswerTableView()
    }
    
    //    MARK: - 设置tableView
    func setupKnowTableView(){
        knowTableView = UITableView(frame: (bgScrollView?.bounds)!, style: .plain)
        self.bgScrollView?.addSubview(knowTableView!)
        knowTableView?.dataSource = self
        knowTableView?.delegate = self
        knowTableView?.tableFooterView = UIView()
        knowTableView?.separatorStyle = .none
        knowTableView?.backgroundColor = .backgroundColor
        knowTableView?.register(CommonNoDataCell.self, forCellReuseIdentifier: CommonNoDataCell.className())
        knowTableView?.register(LImageRContentCell.self, forCellReuseIdentifier: "LImageRContentCell")
        knowTableView?.register(LContentRImageCell.self, forCellReuseIdentifier: "LContentRImageCell")
        knowTableView?.register(TopImageBottomContentCell.self, forCellReuseIdentifier: "TopImageBottomContentCell")
        knowTableView?.register(ItemsCell.self, forCellReuseIdentifier: "ItemsCell")
        knowTableView?.addHeaderRefresh{ [weak self] in
            self?.headerRefresh()
        }
        knowTableView?.addBackFooterRefresh {  [weak self] in
            self?.footerRefresh()
        }
        self.setupHeaderView()
    }
    
    func setupHeaderView(){
        print(kAdScrollViewHeight)
        let scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kAdScrollViewHeight))
        knowTableViewScrollView = scrollView
        scrollView.mBannerClickBlock = {[weak self] (item: BannerModel) in
            self?.bannerDetail(with: item)
        }
    }
    
    func setupAnswerTableView(){
        answerTableView = UITableView(frame: CGRect(x: (knowTableView?.frame.maxX ?? 0), y: 0, width: kScreenWidth, height: (bgScrollView?.frame.size.height ?? 0) - kSegmentBarHeight), style: .plain)
        self.bgScrollView?.addSubview(answerTableView!)
        answerTableView?.dataSource = self
        answerTableView?.delegate = self
        answerTableView?.tableFooterView = UIView()
        answerTableView?.separatorStyle = .none
        answerTableView?.backgroundColor = .backgroundColor
        answerTableView?.register(LImageRContentCell.self, forCellReuseIdentifier: "LImageRContentCell")
        answerTableView?.register(LContentRImageCell.self, forCellReuseIdentifier: "LContentRImageCell")
        answerTableView?.register(TopImageBottomContentCell.self, forCellReuseIdentifier: "TopImageBottomContentCell")
        answerTableView?.register(ItemsCell.self, forCellReuseIdentifier: "ItemsCell")
        answerTableView?.addHeaderRefresh{ [weak self] in
            self?.headerRefresh()
        }
        answerTableView?.addBackFooterRefresh {  [weak self] in
            self?.footerRefresh()
        }
    }
}

extension BaseVC {
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == knowTableView {
            return knowDatas.count == 0 ? 1 : knowDatas.count
        }else{
            return answerDatas.count == 0 ? 1 : answerDatas.count
        }
    }
    //    基类只是准备方法，子类负责具体实现，子类的数据源方法不需要super
     @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.knowTableView {
            if knowDatas.count == 0 {
                let cell: CommonNoDataCell = CommonNoDataCell(style: .default, reuseIdentifier: CommonNoDataCell.className())
                return cell
            }
        }else{
            if answerDatas.count == 0 {
                let cell: CommonNoDataCell = CommonNoDataCell(style: .default, reuseIdentifier: CommonNoDataCell.className())
                return cell
            }
        }
        
        
        var model : HomeModel?
        var isKnow : Bool
        if tableView == self.answerTableView {
            model = self.answerDatas[indexPath.row]
            isKnow = false
        }else{
            model = self.knowDatas[indexPath.row]
            isKnow = true
        }
        
        if model?.push_app_type == .leftImg || model?.push_app_type == .rightImg  || model?.push_app_type == .bigImg {
            let cellId = model?.push_app_type == .leftImg ? "LImageRContentCell" : (model?.push_app_type == .rightImg ? "LContentRImageCell" : "TopImageBottomContentCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BaseHomeCell
            cell?.setupModel(model: model!, indexPathRow:indexPath.row,isKnow: isKnow)
            cell?.homeDelegate = self
            cell?.selectionStyle = .none
            return cell!
        }
        
        else if model?.push_app_type == .group {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as? ItemsCell
            cell?.articles = (model?.articles)!
            cell?.mDelegate = self
            cell?.mTitleLabel?.text = model?.push_app_title
            cell?.selectionStyle = .none
            return cell!
        }
        
        else if !((model?.push_app_type) != nil)  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LContentRImageCell", for: indexPath) as? BaseHomeCell
            cell?.setupModel(model: model!, indexPathRow:indexPath.row,isKnow: isKnow)
            cell?.homeDelegate = self
            cell?.selectionStyle = .none
            return cell!
        }
        
        return UITableViewCell()
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.knowTableView {
            if knowDatas.count == 0 {
                return 300
            }
        }else{
            if answerDatas.count == 0 {
                return 300
            }
        }
        
        var model : HomeModel?
        
        if tableView == self.answerTableView {
             model = self.answerDatas[indexPath.row]
        }else{
             model = self.knowDatas[indexPath.row]
        }
        
        if model?.push_app_type == .leftImg || model?.push_app_type == .rightImg {
            return kSmallImgHeight + kMarginTop + -kMarginBottm - 9
        }else if model?.push_app_type == .bigImg {
            return (model?.hidenBigImgTopLine)! ? kTopImageHeight + 136 : kTopImageHeight + 131 + 20
        }else if model?.push_app_type == .group {
            return  kMargin*3 + kFavoriteBtnHeight + 110 + 135
        }else if !((model?.push_app_type) != nil) {
            return kSmallImgHeight + kMarginTop + -kMarginBottm - 9
        } else {
            return 0
        }
    }

    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if tableView == self.knowTableView {
            if knowDatas.count == 0 {
                return
            }
        }else{
            if answerDatas.count == 0 {
                return
            }
        }
        
        // 防止重复点击
        if mIsSelected {
            delay(2) {[weak self] in
                self?.mIsSelected = false
            }
            return
        }
        
        let model = self.currentIndex == 0 ? self.knowDatas[indexPath.row] : self.answerDatas[indexPath.row]
        pushDetail(with: model)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension BaseVC : UIScrollViewDelegate {
    /// 左右滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.answerTableView || scrollView == self.knowTableView {
            return ;
        }
        self.currentIndex = Int(scrollView.contentOffset.x / kScreenWidth)
        if self.currentIndex == 1 {
            if self.answerDatas.count < 1 {
                self.answerTableView?.beginHeaderRefresh()
            }
        }
        segmentBar?.setScrollViewOffset(offset: scrollView.contentOffset.x)
    }
}


extension BaseVC : BaseHomeCellDelegate {
    
    
    // 收藏事件
    func homeCellFavoriteBtnClick(indexPathRow: Int,isKnow:Bool?, sender: UIButton) {
        
        guard isLogined() else {
            sender.isSelected = false
            return
        }
        
        let model = isKnow! ? self.knowDatas[indexPathRow]  : self.answerDatas[indexPathRow]
        RequestManager.shared.favoriteArticleRequest(articleId: model.id ?? "", commintId: nil, isLike: model.like == 0) {[weak self] (success) in
            if success {
                if model.fav == 0 {
                    model.fav = 1
                    model.fav_count += 1
                    self?.showSuccess(with: "收藏成功")
                    sender.isSelected = true
                    sender.setTitle(model.fav_count.toString, for: .normal)
                } else {
                    model.fav = 0
                    model.fav_count -= 1
                    self?.showSuccess(with: "取消收藏成功 ")
                    sender.isSelected = false
                    sender.setTitle(model.fav_count.toString, for: .normal)
                }
            }
        }
        
    }
    
    // 点赞事件
    func homeCellLikeBtnClick(indexPathRow: Int,isKnow:Bool?, sender: UIButton) {
        
        guard isLogined() else {
            sender.isSelected = false
            return
        }
        
        let model = isKnow! ? self.knowDatas[indexPathRow]  : self.answerDatas[indexPathRow]
        RequestManager.shared.likeArticleRequest(articleId: model.id ?? "", commintId: nil, isLike: model.like == 0) {[weak self] (success) in
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

// MARK: - REQUEST -
extension BaseVC {
    
    func requestHomeData(with module: Module_Type, isFooter: Bool ) {
        let params = [
            "client_type": "APP",
            "module": module == .home ? "" : module.rawValue,
            "classify": currentIndex == 0 ? "KNOW" : "SOLVE",
            "title": "",
            "user_id": "",
            "scope": "AUTO",
            "push_module": module.rawValue,
            "push_classify": currentIndex == 0 ? "KNOW" : "SOLVE",
            "push_type": "",
            "page_index": currentIndex == 0 ? mKnowPageIndex : mAnswerPageIndex,
            "page_size": DefaultPageSize,
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_ArticleList, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let HomeModels = [HomeModel].deserialize(from: toJSONString(arr: itemArr!)) {
                    /// 知
                    if self?.currentIndex == 0 {
                        
                        /// 底部刷新
                        if isFooter {
                            self?.knowDatas += HomeModels as! [HomeModel]
                            
                            if result["total"].intValue <= (self?.knowDatas.count)! {
                                self?.knowTableView?.endFooterRefreshWithNoMoreData()
                            }
                            
                            else {
                                self?.endRefresh()
                            }
                        }
                        
                        else {
                            self?.knowDatas = HomeModels as! [HomeModel]
                            self?.endRefresh()
                            self?.knowTableView?.resetNoMoreData()
                        }
                        // self?.knowTableView?.reloadData()
                    }
                    
                    /// 解
                    else {
                        
                        if isFooter {
                            self?.answerDatas += HomeModels as! [HomeModel]
                            if result["total"].intValue <= (self?.answerDatas.count)! {
                                self?.answerTableView?.endFooterRefreshWithNoMoreData()
                            }
                        }
                        
                        else {
                            self?.answerDatas = HomeModels as! [HomeModel]
                            self?.endRefresh()
                            self?.answerTableView?.resetNoMoreData()
                        }
                        // self?.answerTableView?.reloadData()
                    }
                }
                
                else {
                    self?.endRefresh()
                }
            }
            
            else {
                self?.endRefresh()
            }
        }
    }
    
    
}

extension BaseVC: ItemCellCollectionItemDidSelected {
    func collectionItemClick(article: HomeModel?) {
        pushDetail(with: article)
    }
}


// MARK: - BANNER -
extension BaseVC {
    func requestBanner(with module: Module_Type) {
        let moduleType = module == .home ? "HOME" : (module == .play_car ? "PLAY_CAR" : "TOY")
        // 目前只有 知 有 banner
        //let calssifyType = self.currentIndex == 0 ? "KNOW" : "SOLVE"
        let params = [
            "module": moduleType,
            "classify": "KNOW",
            ]
        RequestManager.shared.Post(URLString: URL_Slideshow, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let BannerModels = [BannerModel].deserialize(from: toJSONString(arr: itemArr!)) {
                    if BannerModels.count > 0 {
                        self?.knowTableViewScrollView?.items = BannerModels as! [BannerModel]
                        self?.knowTableViewScrollView?.frame = CGRect(x: 0, y: 0, w: kScreenWidth, h: kAdScrollViewHeight)
                        self?.knowTableView?.tableHeaderView = self?.knowTableViewScrollView
                        self?.knowTableView?.reloadData()
                    } else {
                        self?.knowTableView?.tableHeaderView = nil
                    }
                } else {
                    self?.knowTableView?.tableHeaderView = nil
                }
            }
        }
    }
    
    // Banner 点击跳转事件
    // 跳转详情页
    func bannerDetail(with bannerModel: BannerModel) {
        if bannerModel.type == .link {
            let webVC = WebViewController()
            webVC.mUrlString = bannerModel.url
            webVC.title = bannerModel.title
            pushVC(webVC)
        }
        
        if bannerModel.type == .article {
            pushDetail(with: bannerModel.article_id)
        }
    }
    
    
    // 获取用户信息, 判断是否有福袋可领取, 判断菜单按钮用户新消息数量
    func getUserInfo() {
        let logined = UserDefaults.standard.bool(forKey: Key_ISLogined)
        print("logined: \(logined)")
        guard UserDefaults.standard.bool(forKey: Key_ISLogined) else {
            return
        }
        
        let params: [String: Any] = [:]
        
        RequestManager.shared.Post(URLString: URL_UserInfo, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 更新用户信息
                UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                UserInfo.current.initWith(json: result["rsp_content"])
                if UserInfo.current.points_dlbag == 1 {
                    self?.view.addSubview((self?.mLuckyBagView)!)
                    AssistiveBtn.shared.isHidden = true
                }
                
                if UserInfo.current.new_comment! > 0 {
                    AssistiveBtn.shared.mHaveNewMsg = true  
                } else {
                    AssistiveBtn.shared.mHaveNewMsg = false
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(kReloadMenuTableView), object: nil)
            }
        }
    }
}
