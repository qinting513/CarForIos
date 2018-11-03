//
//  DetailViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYKit
import JavaScriptCore
import EZSwiftExtensions

let TAG_CONTROL = 10010

class DetailViewController: UIViewController, YYTextViewDelegate, CommentsTableViewCellDelegte{
    
    var isSelected:Bool = false
    
    /// 用于监听多次点击
    var mIsClick:Bool = false
    
    // 文章图片标记点击后的遮罩层
    lazy var mControl : UIControl = {
        let control = UIControl(frame: UIScreen.main.bounds)
        control.backgroundColor = RGBA(r: 127, g: 127, b: 127, a: 0.8)
        control.tag = TAG_CONTROL
        control.addTarget(self, action: #selector(imageCoverClickAction), for: .touchUpInside)
        return control
    }()
    
    lazy var mControlImageView : UIImageView = {
        let imageView = UIImageView(image: .defaultNoData)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.frame = CGRect(x: 30, y: 220, w: kScreenWidth - 60, h: 200)
        return imageView
    }()
    
    lazy var mControlLableView : ImgTagLableView = {
        let labelView = ImgTagLableView(frame: CGRect(x: 30, y: 220, w: kScreenWidth - 60, h: 180))
        return labelView
    }()
    
    var webView: UIWebView!
    var jsContext: JSContext!
    
    // 文章模型
    var article: ActicleModel?
    // 评论数据
    var datas = [CommentModel]()
    // 当前选择评论 indexpath
    var mCurrentIndexPath: IndexPath?
    
    var mSelectedCommentUser: CommentModel?
    
    let detailHeaderView = DetailHeaderView()
    let detailFooterView = CommonInput()
    var isFromUserInfo :Bool = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        // 注册cellID
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(CommonNoDataCell.self, forCellReuseIdentifier: "TableViewNoDataCell")
        return tableView
    }()


    /// 加载 webview 进度
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: 0, w: kScreenWidth, h: 1))
        self.progressView.tintColor = .mainColor      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if article != nil {
            requestComments(article: article!)
        }
        
        AssistiveBtn.shared.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hidenLoading()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = article?.module == .toy ? "顽技" : "顽车"

        showLoading()
        
        // TableView Header
        detailHeaderView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight+300)
        detailHeaderView.contentLabel?.delegate = self
        detailHeaderView.mHeaderRefreshBlock = { [weak self] (headerHeight: CGFloat) in
            self?.detailHeaderView.frame = CGRect(x: 0, y: 0, w: kScreenWidth, h: headerHeight)
            UIView.animate(withDuration: 0.5, animations: {
                self?.tableView.reloadData()
            })
            self?.hidenLoading()
        }
        tableView.tableHeaderView = detailHeaderView
        detailHeaderView.favoriteBtn?.addTarget(self, action: #selector(favBtnAction), for: .touchUpInside)
        detailHeaderView.likeBtn?.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
        detailHeaderView.mWechatFriendsBtn?.addTarget(self, action: #selector(shareWechatFriendsBtnAction), for: .touchUpInside)
        detailHeaderView.mWechatCircleBtn?.addTarget(self, action: #selector(shareWechatCircleBtnAction), for: .touchUpInside)
        detailHeaderView.mWeiboBtn?.addTarget(self, action: #selector(shareWeiboBtnAction), for: .touchUpInside)

        detailHeaderView.avatarImageView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoUserInfo))
        detailHeaderView.avatarImageView?.addGestureRecognizer(tap)
        detailHeaderView.mAllCommentBtn?.addTarget(self, action: #selector(allCommentBtnClick), for: .touchUpInside)
        
        // TableView Footer
        //tableView.tableFooterView = detailFooterView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0))
        }
        view.addSubview(detailFooterView)
        detailFooterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        // 给 footer 里面的内容添加事件
        detailFooterView.mSendBtn?.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        detailFooterView.mInputTextField?.delegate = self
        
        
        
        // 监听键盘高度
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(detailImageTagClickAction), name: NSNotification.Name(kDetailImageTagClickAction), object: nil)
        
        if article != nil {
            detailHeaderView.article = article
            requestComments(article: article!)
        }
    }
    
    
    @objc func allCommentBtnClick(){
        let vc = AllCommentsViewController()
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func gotoUserInfo(){
        //  如果从用户信息界面过来的 则点击头像返回上一页
        if isFromUserInfo {
            popVC()
            return
        }
        let vc = UserInfoViewController()
        vc.view.backgroundColor = .backgroundColor
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval

        // 2.获取键盘最终 Y值
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        let keyboardHeight = kScreenHeight - y

        //计算工具栏距离底部的间距
        var tableviewFrame = view.frame
        
        // 键盘弹起
        if UIScreen.main.bounds.size.height - y > 0{
            tableviewFrame.origin.y =  0 - keyboardHeight
        } else {
            tableviewFrame.origin.y = 0
        }
        UIView.animate(withDuration: duration) {[weak self] in
            self?.view.frame = tableviewFrame
        }
    }
    
    // MARK - Request -
    func requestComments(article: ActicleModel) {
        let params = [
            "article_id": article.id ?? "",
            "page_index": 1,
            "hot": 1,
            "page_size": 3 // 最多显示三条数据
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_ArticleCommentList, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let commonts = [CommentModel].deserialize(from: toJSONString(arr: itemArr ?? [])) {
                    self?.datas = commonts as! [CommentModel]
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - UITableViewDataSource,UITableViewDelegate -
extension DetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 如果没有数据显示暂无数据图片, 最多显示三条数据
        let count = self.datas.count == 0 ? 1 : self.datas.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 暂无数据图片
        if self.datas.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewNoDataCell", for: indexPath) as? CommonNoDataCell
            cell?.mIsComment = true
            return cell ?? UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell
        cell?.comment = datas[indexPath.row]
        cell?.mIndexPath = indexPath
        cell?.mDelegate = self
        
        if indexPath.row == datas.count-1 {
            cell?.mBottomLine?.isHidden = true
        } else {
            cell?.mBottomLine?.isHidden = false
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.datas.count == 0 {
            return 300
        }
        let comment = datas[indexPath.row]
        return comment.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mCurrentIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        // 暂无数据图片
        if self.datas.count == 0 {
            return
        }
        
        // 不能回复自己的内容
        if datas[indexPath.row].user_id == UserInfo.current.id {
            return
        }
        
        respondToUser()
    }
    
    // 在 canPerformAction(_:withSender:) 中让 items 所对应的方法得以显示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print(action)
        if action == #selector(respondToUser) || action == #selector(copyContent) {
            return true
        }
        return false
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: - 事件处理
    // 回复用户
    @objc func respondToUser(){
        let comment = datas[mCurrentIndexPath?.row ?? 0]
        self.commentsCellRespondComment(indexPathRow: mCurrentIndexPath?.row ?? 0 , comment:comment)
    }
    @objc func copyContent(){
        let comment = datas[mCurrentIndexPath?.row ?? 0]
        let board = UIPasteboard.general
        board.string = comment.content
    }
    
    //MARK: - 滚动停止
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if  detailFooterView.mInputTextField?.text.trimmed().length == 0 {
            detailFooterView.mInputTextField?.placeholderText = "发表评论..."
            mSelectedCommentUser = nil
        }
    }
    
}


// MARK: - 页面按钮点击事件 -
extension DetailViewController {
    
    
    @objc func likeBtnAction(btn: UIButton) {
        guard isLogined() else {
            return
        }
        
        print("likeBtnAction")
        RequestManager.shared.likeArticleRequest(articleId: article?.id ?? "", commintId: nil, isLike: article?.like == 0) {[weak self] (success) in
            if success {
                if self?.article?.like == 0 {
                    self?.article?.like = 1
                    self?.article?.like_count += 1
                    self?.showSuccess(with: "谢谢您的点赞！✌️")
                    btn.isSelected = true
                    btn.setTitle(self?.article?.like_count.toString, for: .normal)
                } else {
                    self?.article?.like = 0
                    self?.article?.like_count -= 1
                    self?.showSuccess(with: "取消点赞成功 ")
                    btn.isSelected = false
                    btn.setTitle(self?.article?.like_count.toString, for: .normal)
                }
            }
        }
    }
    @objc func favBtnAction(btn: UIButton) {
        
        guard isLogined() else {
            return
        }
        
        RequestManager.shared.favoriteArticleRequest(articleId: article?.id ?? "", commintId: nil, isLike: article?.fav == 0) {[weak self] (success) in
            if success {
                if self?.article?.fav == 0 {
                    self?.article?.fav = 1
                    self?.article?.fav_count += 1
                    self?.showSuccess(with: "收藏成功！✌️")
                    btn.isSelected = true
                    btn.setTitle(self?.article?.fav_count.toString, for: .normal)
                } else {
                    self?.article?.fav = 0
                    self?.article?.fav_count -= 1
                    self?.showSuccess(with: "取消收藏成功 ")
                    btn.isSelected = false
                    btn.setTitle(self?.article?.fav_count.toString, for: .normal)
                }
            }
        }
        
    }
    @objc func sendBtnClick(btn: UIButton) {
        btn.cancelContinuousClicks()

        guard mIsClick == false else {
            return
        }
        
        mIsClick = true
        
        guard isLogined() else {
            return
        }
        
        let content: String = detailFooterView.mInputTextField?.text.trimmed() ?? ""
        guard content.length > 0 else {
            self.showError(with: "请先输入评论内容")
            return
        }
        let params = [
            "article_id": article?.id ?? "",
            "comment_id": mSelectedCommentUser?.id ?? "",
            "content": content
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_ArticleComment, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.view.endEditing(true)
                self?.mSelectedCommentUser = nil
                self?.showSuccess(with: "发表评论成功 (●ﾟωﾟ●)")
                self?.detailFooterView.mInputTextField?.text = ""
                self?.detailFooterView.mInputTextField?.placeholderText = "发表评论..."
                self?.mSelectedCommentUser = nil
                if self?.article != nil {
                    self?.requestComments(article: (self?.article)!)
                }
                self?.mIsClick = false
            }
        }
    }
}

// MARK: - YYTextViewDelegate -
extension DetailViewController {
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        return isLogined()
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let originText = textView.text {
            if (originText + text).length > 0 {
                detailFooterView.mSendBtn?.isEnabled = true
                detailFooterView.mSendBtn?.layer.borderColor = UIColor.mainColor.cgColor
                detailFooterView.mSendBtn?.setTitleColor(.mainColor, for: .normal)
            } else {
                detailFooterView.mSendBtn?.isEnabled = false
                detailFooterView.mSendBtn?.layer.borderColor = UIColor.lineColor.cgColor
                detailFooterView.mSendBtn?.setTitleColor(.lineColor, for: .normal)
            }
        }
        
        if text == "\n" {
            sendBtnClick(btn:UIButton())
            return false
        }
        
        let textLength = textView.text.length + text.length
        if textLength > 1000 {
            showError(with: "请输入1-1000以内的内容")
            return false
        }
        return true
    }
    
    
    func heightForTextView(textView: YYTextView, strText: String) -> CGFloat{
        let constraint: CGSize = CGSize(width: textView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = textView.sizeThatFits(constraint)
        return size.height + 10.0;
    }

    func textViewDidChange(_ textView: YYTextView) {
        if let text = textView.text {
            if text.length > 0 {
                detailFooterView.mSendBtn?.isEnabled = true
                detailFooterView.mSendBtn?.layer.borderColor = UIColor.mainColor.cgColor
                detailFooterView.mSendBtn?.setTitleColor(.mainColor, for: .normal)
            } else {
                detailFooterView.mSendBtn?.isEnabled = false
                detailFooterView.mSendBtn?.layer.borderColor = UIColor.lineColor.cgColor
                detailFooterView.mSendBtn?.setTitleColor(.lineColor, for: .normal)
            }
        }
    }
}

// MARK: - CommentsTableViewCellDelegte -
extension DetailViewController {
    func commentsCellLikeBtnClick(indexPathRow: Int, isKnow: Bool?, comment: CommentModel?, sender: UIButton) {
        
        print("commentsCellLikeBtnClick")
        
        guard isLogined() else {
            return
        }
        RequestManager.shared.likeArticleRequest(articleId: article?.id ?? "", commintId: comment?.id ?? "", isLike: comment?.like == 0) {[weak self] (success) in
            if success {
                if comment?.like == 0 {
                    comment?.like = 1
                    comment?.like_count += 1
                    sender.isSelected = true
                    sender.setTitle(comment?.like_count.toString, for: .normal)
                     self?.showSuccess(with: "谢谢您的点赞！✌️")
                } else {
                    comment?.like = 0
                    sender.isSelected = false
                    comment?.like_count -= 1
                    sender.setTitle(comment?.like_count.toString, for: .normal)
                    self?.showSuccess(with: "取消点赞成功 >_<")
                }
            }
        }
    }
    
    func commentsCellHeaderBtnClick(indexPathRow: Int, isKnow: Bool?, comment: CommentModel?, sender: UIButton) {
        
    }
    
    func commentsCellRespondComment(indexPathRow: Int, comment: CommentModel?) {
        self.mSelectedCommentUser = comment
        if comment?.user_nickname?.trimmed().length == 0 {
            comment?.user_nickname = "匿名用户"
        }
        detailFooterView.mInputTextField?.placeholderText = "回复 " + (comment?.user_nickname ?? "") + "... :"
        detailFooterView.mInputTextField?.becomeFirstResponder()
    }
}


//MARK:  - 第三方分享 -
extension DetailViewController {
    @objc func shareWechatFriendsBtnAction() {
        guard isLogined() else {
            return
        }
        
        let url = "\(AppInfo.shared.web_base_url ?? "")article/?id=" + (article?.id ?? "")
        let image = detailHeaderView.adImageView?.image
        let title = article?.title ?? ""
        let des = article?.content ?? ""
        wechatShare(url: url, image: image!, title: title, description: des, to: .Session)
    }
    
    @objc func shareWechatCircleBtnAction() {
        guard isLogined() else {
            return
        }
        
        let url = "\(AppInfo.shared.web_base_url ?? "")article/?id=" + (article?.id ?? "")
        let image = detailHeaderView.adImageView?.image
        let title = article?.title ?? ""
        let des = article?.content ?? ""
        wechatShare(url: url, image: image!, title: title, description: des, to: .Timeline)
    }
    
    @objc func shareWeiboBtnAction() {
        guard isLogined() else {
            return
        }
        
        let url = "\(AppInfo.shared.web_base_url ?? "")article/?id=" + (article?.id ?? "")
        let image = detailHeaderView.adImageView?.image
        let title = article?.title ?? ""
        let des = article?.content ?? ""
        weiboShare(url: url, image: image!, title: title, description: des)
    }
}
