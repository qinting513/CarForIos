//
//  MyNoticeViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import YYKit

class MyNoticeViewController: UIViewController {
    
    var mPageNumber: Int = 1
    
    var mIsSelected: Bool = false
    
    // 当前需要回复的评论
    var mCurrentReplayComment: CommentModel?
    
    // 当前输入框的内容, 默认保存
    var mCurrentContent: String?
    
    lazy var mInputView: CommonInput = {
        let input = CommonInput(frame: CGRect(x: 0, y: view.frame.size.height - 44, w: view.frame.width, h: 44))
        input.mSendBtn?.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        input.mInputTextField?.delegate = self
        return input
    }()

    // tableView
    lazy var tableView: UITableView = {
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, w: view.frame.size.width, h: view.frame.size.height - 43)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let footer = UIView()
        footer.backgroundColor = .backgroundColor
        tableView.tableFooterView = footer
        tableView.backgroundColor = .backgroundColor
        // 注册cellID
        tableView.register(NoticeCell.self, forCellReuseIdentifier: "NoticeCell")
        tableView.register(CommonNoDataCell.self, forCellReuseIdentifier: "TableViewNoDataCell")
        return tableView
    }()
    
    var datas = [CommentModel]() {
        didSet {
            mInputView.isHidden = datas.count == 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AssistiveBtn.shared.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的通知"
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .backgroundColor
        view.addSubview(self.tableView)
        /// 清除通知的数量
        UserInfo.current.new_comment = 0
        
        // 移除菜单栏我的 新图标
        NotificationCenter.default.post(name: NSNotification.Name(kReloadMenuTableView), object: nil)
        AssistiveBtn.shared.mHaveNewMsg = false
        
        requestNotices()
        tableView.reloadData()
        
        view.addSubview(mInputView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func requestNotices() {
        let params = [
            "page_index": mPageNumber,
            "page_size": kPageSize
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_MyNotify, parameters: params) { [weak self] (resultValue) in
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
    
    @objc func sendBtnClick() {
        let content: String = mInputView.mInputTextField?.text.trimmed() ?? ""
        guard content.length > 0 else {
            self.showError(with: "请先输入评论内容")
            return
        }

        let params = [
            "article_id": mCurrentReplayComment?.article?.id ?? "",
            "comment_id": mCurrentReplayComment?.id ?? "",
            "content": content
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_ArticleComment, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.view.endEditing(true)
                self?.showSuccess(with: "发表评论成功 (●ﾟωﾟ●)")
                self?.mInputView.mInputTextField?.text = ""
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 2.获取键盘最终 Y值
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        let keyboardHeight = kScreenHeight - y
        
        var tableviewFrame = view.frame
        print(NSStringFromCGRect(tableviewFrame))
        
        // 键盘弹起
        if UIScreen.main.bounds.size.height - y > 0{
            //tableviewFrame.origin.y =  kNavBarHeight - keyboardHeight
            tableviewFrame.origin.y =  -keyboardHeight
        } else {
            tableviewFrame.origin.y = 0
        }
        UIView.animate(withDuration: duration) {[weak self] in
            self?.view.frame = tableviewFrame
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension MyNoticeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.datas.count == 0 ? 1 : self.datas.count
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 暂无数据图片
        if self.datas.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewNoDataCell", for: indexPath) as? CommonNoDataCell
            cell?.mNoDataImg?.snp.updateConstraints({ (make) in
                make.top.equalToSuperview().offset(157)
            })
            cell?.mDesLabel?.text = "暂时没有通知"
            return cell ?? UITableViewCell()
        }
        
        let model = datas[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as? NoticeCell
        cell?.mComment = model
        cell?.mDelegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.datas.count == 0 {
            return kScreenHeight - kNavBarHeight - 34
        }
        let model = datas[indexPath.section]
        return model.mNoticeCellHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 默认无数据的图片
        if self.datas.count == 0 {
            return
        }
        
        // 防止重复点击
        if mIsSelected {
            delay(1) {[weak self] in
                self?.mIsSelected = false
            }
            return
        }
        
        mIsSelected = true
        pushDetail(with: datas[indexPath.section].article?.id)
    }
}


extension MyNoticeViewController: NoticeCellDidSelectedDelegate {
    func NoticeCellReplyBtnDidSelected(comment: CommentModel) {
        mCurrentReplayComment = comment
        mInputView.mInputTextField?.becomeFirstResponder()
    }
    
    func NoticeCellCommonDidSelected(comment: CommentModel) {
        
        showLoading()
        if mIsSelected {
            delay(2) {[weak self] in
                self?.mIsSelected = false
            }
            return
        }
        
        
        requestDetail(with: comment.article?.id, finishedCallback: {[weak self] (result) in
            if let articleModel: ActicleModel = result as? ActicleModel {
                let vc = AllCommentsViewController()
                vc.article = articleModel
                self?.pushVC(vc)
            } else {
                self?.showError(with: "获取文章详情失败")
            }
        })
    }
    
    func NoticeCellArticleDidSelected(comment: CommentModel) {
        showLoading()
        if mIsSelected {
            delay(2) {[weak self] in
                self?.mIsSelected = false
            }
            return
        }
        
        mIsSelected = true
        pushDetail(with: comment.article?.id)
    }
}

extension MyNoticeViewController: YYTextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        
        if mCurrentReplayComment != nil {
            
            textView.placeholderText = "@" + (mCurrentReplayComment?.user_nickname ?? "匿名用户") + ": "
            textView.text = ""
            return true
        } 
        
        showError(with: "请选择一条评论回复")
        return false
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            sendBtnClick()
            return false
        }
        
        let textLength = textView.text.length + text.length
        
        if textLength > 1000 {
            showError(with: "请输入1-1000以内的内容")
            return false
        }
        return true
    }
}

