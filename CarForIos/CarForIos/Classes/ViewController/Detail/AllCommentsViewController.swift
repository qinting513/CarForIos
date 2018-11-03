//
//  AllCommentsViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYKit

class AllCommentsViewController: UIViewController, YYTextViewDelegate, CommentsTableViewCellDelegte{
  
    // 当前选择评论
    var mCurrentIndexPath: IndexPath?
    
    // 文章模型
    var article: ActicleModel?
    
    // 评论数据
    var datas = [CommentModel]()
        
    var mSelectedCommentUser: CommentModel?

    let detailFooterView = CommonInput()
    let footViewHeight :CGFloat = 44.0
    
    ///评论某条评论的
    var currentCommentUserId : String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight-kNavBarHeight-footViewHeight), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        // 注册cellID
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(CommonNoDataCell.self, forCellReuseIdentifier: "TableViewNoDataCell")
        return tableView
    }()
        
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if article != nil {
            requestComments(article: article!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部评论"
        self.view.addSubview(tableView)
        
        hidenLoading()
            
        detailFooterView.frame = CGRect(x: 0, y: kScreenHeight - footViewHeight, width: kScreenWidth, height: footViewHeight)
//        detailFooterView.mInputHeightRefreshBlock = { [weak self] (maxHeight: CGFloat) in
//            self?.tableView.beginUpdates()
//            self?.detailFooterView.frame = CGRect(x: 0, y: 0, w: kScreenWidth, h: maxHeight)
//            self?.tableView.endUpdates()
//            let maxH: CGFloat = self?.tableView.contentSize.height ?? 0
//            let pointH:CGFloat = maxH - kScreenHeight + kNavBarHeight
//            self?.tableView.setContentOffset(CGPoint(x: 0, y: pointH), animated: true)
//        }
        self.view.addSubview( detailFooterView )
        // 给 footer 里面的内容添加事件
        detailFooterView.mSendBtn?.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        detailFooterView.mInputTextField?.delegate = self
            
        // 监听键盘高度
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(_ note: Notification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            
        // 2.获取键盘的size
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //3. 键盘的y偏移量
            let changeY =  endFrame.origin.y - kScreenHeight
        
        UIView.animate(withDuration: duration) {[weak self] in
            self?.detailFooterView.transform = CGAffineTransform(translationX: 0, y:changeY)
        }
    }
    
    @objc func keyBoardWillHide(_ note: Notification){
        // 1.获取动画执行的时间
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration) {[weak self] in
            self?.detailFooterView.transform  = CGAffineTransform.identity
        }
    }
    
    // MARK - Request -
    func requestComments(article: ActicleModel) {
        showLoading()
        let params = [
            "article_id": article.id ?? "",
            "page_index": 1,
            "page_size": 30
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_ArticleCommentList, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                let itemArr = result["rsp_content"]["items"].arrayObject
                if let commonts = [CommentModel].deserialize(from: toJSONString(arr: itemArr ?? [])) {
                    self?.datas = commonts as! [CommentModel]
                    self?.tableView.reloadData()
                    self?.hidenLoading()
                }
            }
        }
    }
}


extension AllCommentsViewController:UITableViewDataSource,UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.datas.count == 0 {
                return 1
            }
            return self.datas.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // 暂无数据图片
            if self.datas.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewNoDataCell", for: indexPath) as? CommonNoDataCell
                cell?.mDesLabel?.text = "暂时没有评论"
                return cell ?? UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell
            cell?.comment = datas[indexPath.row]
            cell?.mBottomLine?.isHidden = true
            cell?.mIndexPath = indexPath
            cell?.mDelegate = self
            return cell ?? UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if self.datas.count == 0 {
                return kScreenHeight - kNavBarHeight
            }
            let comment = datas[indexPath.row]
            return comment.cellHeight
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mCurrentIndexPath = indexPath
        
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = HexString(hex: "F8F8F8")
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
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
extension AllCommentsViewController {
    
        @objc func sendBtnClick() {
            guard isLogined() else {
                self.showError(with: "请先登录...")
                return
            }
            
            let content: String = detailFooterView.mInputTextField?.text.trimmed() ?? ""
            guard content.length > 1 else {
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
                }
            }
        }
    }
    
    // MARK: - YYTextViewDelegate -
extension AllCommentsViewController {
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
            sendBtnClick()
            return false
        }
        
        if textView.text.length + text.length > 1000 {
            showError(with: "请输入1-1000以内的内容")
            return false
        }
        
        return true
    }

}


    // MARK: - CommentsTableViewCellDelegte -
extension AllCommentsViewController {
    //评论Cell点赞按钮
        func commentsCellLikeBtnClick(indexPathRow: Int, isKnow: Bool?, comment: CommentModel?, sender: UIButton) {
            guard isLogined() else {
                return
            }
            RequestManager.shared.likeArticleRequest(articleId: article?.id ?? "", commintId: comment?.id ?? "", isLike: comment?.like == 0) {[weak self] (success) in
                if success {
                    if comment?.like == 0 {
                        comment?.like = 1
                        comment?.like_count += 1
                        self?.showSuccess(with: "谢谢您的点赞！✌️")
                        sender.isSelected = true
                        sender.setTitle(comment?.like_count.toString, for: .normal)
                    } else {
                        comment?.like = 0
                        comment?.like_count -= 1
                        self?.showSuccess(with: "取消点赞成功 >_< ")
                        sender.isSelected = false
                        sender.setTitle( comment?.like_count.toString, for: .normal)
                    }
                }
            }
        }
    //TODO:评论cell头像点击事件 还没做
        func commentsCellHeaderBtnClick(indexPathRow: Int, isKnow: Bool?, comment: CommentModel?, sender: UIButton)
        {
            
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

