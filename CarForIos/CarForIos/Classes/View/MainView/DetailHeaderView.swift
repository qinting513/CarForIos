//
//  DetailHeaderView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/18.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftRichString
import EZSwiftExtensions
import YYKit


class DetailHeaderView: UIView {
    
    var mWechatFriendsBtn: UIButton?
    var mWechatCircleBtn: UIButton?
    var mWeiboBtn: UIButton?
    var mAllCommentBtn:UIButton?

    
    let adImageViewHeight : CGFloat = 200.0
    var adImageView : UIImageView?
    var titleLabel : UILabel?
    ///  作者头像
    var avatarImageView : UIImageView?
    /// 作者名称
    var userNameLabel : UILabel?
    /// 类型标签： 首页、玩车、玩具
    var tagLabel : UILabel?
    /// 时间
    var timeLabel : UILabel?
    /// 点赞按钮
    var likeBtn : UIButton?
    ///  收藏按钮
    var favoriteBtn : UIButton?
    /// 内容
    var contentLabel : UIWebView?
    /// 内容图片
    var contentImageView : UIImageView?
    
    var mMoreBtn: UIButton?
    
    var mBottomLine: UIView?
    
    var mTitleLabelHeight: CGFloat = 30
    
    var mRegistered: Bool = false
    
    // 使用 kvo 监听 content web 加载,加载完成后获取 webview 的高度,然后回调设置 tableview header
    var mHeaderRefreshBlock: ((_ maxHeight: CGFloat)->())?
    
    var article: ActicleModel? = nil {
        didSet{
            if article != nil {
                titleLabel?.text = article?.title
                adImageView?.setImage(with: URL(string: (article?.image_url)!))
                avatarImageView?.setImage(with: URL(string: (article?.user_avatar)!), placeHolder: .defaultHeader)
                userNameLabel?.text = (article?.user_name?.length)! < 1 ? "春风十里不如你" : article?.user_name
                timeLabel?.text = article?.create_time?.maxLength(maxLength: 10)
                let urlString = (article?.content_base_url ?? "") + "webview/?id=" + (article?.id)!
                let url = NSURL(string: urlString)

                contentLabel?.loadRequest(URLRequest(url: url! as URL))

                let height = getTextHeigh(textStr: article?.title ?? "", font: 20, width: kScreenWidth - 30)
                mTitleLabelHeight = height
                titleLabel?.snp.updateConstraints({ (make) in
                    make.height.equalTo(height+10)
                })
                
                favoriteBtn?.isSelected = article?.fav == 1
                favoriteBtn?.setTitle(article?.fav_count.toString, for: .normal)
                likeBtn?.isSelected = article?.like == 1
                likeBtn?.setTitle(article?.like_count.toString, for: .normal)
                
                tagLabel?.text = article?.module == .toy ? "顽技" : "顽车"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        adImageView = UIImageView(image: getImageWithColor(color: .cyan))
        self.addSubview(adImageView!)
        adImageView?.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().offset(0)
            make.height.equalTo(adImageViewHeight)
        }
        
        tagLabel = UILabel()
        tagLabel?.text = "顽车"
        tagLabel?.textColor = .white
        tagLabel?.font = SystemFonts.PingFangSC_Semibold.font(size: 11)
        tagLabel?.backgroundColor = RGB(r: 258, g: 57, b: 60)
        tagLabel?.textAlignment = .center
        self.addSubview(tagLabel!)
        tagLabel?.layer.cornerRadius = 5.0
        tagLabel?.layer.masksToBounds = true
        tagLabel?.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(kMarginLeft)
            make.height.equalTo(18)
            make.width.equalTo(40)
            make.top.equalTo(adImageView?.snp.bottom ?? 0).offset(20)
        }
        

        titleLabel = UILabel()
        titleLabel?.textColor = HexString(hex: "222222")
        titleLabel?.text = "科幻悍将 实拍奥迪首款轿跑型SUV Q8精彩绝伦 美轮美奂"
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .left
        titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 20)
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalTo(tagLabel?.snp.bottom ?? 0).offset(kMarginTop)
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(kMarginRight)
        })
        
        
        avatarImageView = UIImageView(image: getImageWithColor(color: .darkGray))
        self.addSubview(avatarImageView!)
        let iconWH : CGFloat = 25.0
        avatarImageView?.layer.cornerRadius = iconWH * 0.5
        avatarImageView?.layer.masksToBounds = true
        avatarImageView?.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.width.height.equalTo(iconWH)
            make.top.equalTo(titleLabel?.snp.bottom ?? 0).offset(kMarginTop)
        }
        
        userNameLabel = UILabel(withText: "作者名称", fontSize: 13,
                                color: .lightGray, numberOfLines: 1)
        self.addSubview(userNameLabel!)
        userNameLabel?.textColor = HexString(hex: "666666")
        userNameLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 12)
        userNameLabel?.textAlignment = .left
        userNameLabel?.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView?.snp.centerY ?? 0)
            make.height.equalTo(22)
            make.left.equalTo(avatarImageView?.snp.right ?? 0).offset(kMargin)
            make.width.greaterThanOrEqualTo(80)
        }
        
        
        timeLabel = UILabel(withText: "2018-07-18", fontSize: 18,
                            color: .darkGray, numberOfLines: 1)
        self.addSubview(timeLabel!)
        timeLabel?.textColor = RGB(r: 153, g: 153, b: 153)
        timeLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 11)
        timeLabel?.textAlignment = .right
        timeLabel?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.centerY.equalTo(avatarImageView?.snp.centerY ?? 0)
            make.height.equalTo(22)
            make.width.greaterThanOrEqualTo(20)
        }
        
        let contentView = UIWebView()
        addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        contentView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(avatarImageView?.snp.bottom ?? 0)
            make.height.equalTo(20)
        })
        contentLabel = contentView
        
        // 点赞按钮
        let likeBtnHeight = 10
        likeBtn = UIButton(title: "", titleColor: .black, img: "feed_video_unlike", selectedImg: "feed_video_like")
        addSubview(likeBtn!)
        likeBtn?.setTitleColor(HexString(hex: "999999"), for: .normal)
//        likeBtn?.imageEdgeInsets = UIEdgeInsets(top: 4, left: 2, bottom: 9, right: 9)
        likeBtn?.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 15)
        likeBtn?.layer.masksToBounds = true
        likeBtn?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(contentLabel?.snp.bottom ?? 0).offset(kMarginTop)
            make.height.equalTo(likeBtnHeight)
            make.width.equalTo(50)
        }
        
        let favBtn = UIButton(title: "", titleColor: .black, img: "IMG_Favorite", selectedImg: "IMG_Favorite_Light")
        addSubview(favBtn!)
        favBtn?.setTitleColor(HexString(hex: "999999"), for: .normal)
        favBtn?.titleLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 15)
//        favBtn?.imageEdgeInsets = UIEdgeInsets(top: 6, left: 2, bottom: 8, right: 9)
        favBtn?.snp.makeConstraints({ (make) in
            make.width.equalTo(50)
            make.height.equalTo(likeBtnHeight)
            make.right.equalTo(likeBtn?.snp.left ?? 0)
            make.centerY.equalTo(likeBtn?.snp.centerY ?? 0)
        })
        favoriteBtn = favBtn
        
        // MARK: - 分割线, 点赞下面的线条 -
        let middleLinView = UIView()
        middleLinView.backgroundColor = UIColor(hexString: "#F8F8F8")
        addSubview(middleLinView)
        middleLinView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(likeBtn?.snp.bottom ?? 0).offset(kMarginTop)
        }
        
        let shareCenterLabel = UILabel(frame: .zero)
        addSubview(shareCenterLabel)
        shareCenterLabel.text = "分享"
        shareCenterLabel.font = SystemFonts.PingFangSC_Semibold.font(size: 15)
        shareCenterLabel.textAlignment = .center
        shareCenterLabel.textColor = .black
        shareCenterLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.top.equalTo(middleLinView.snp.bottom)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(42)
        }
        
        let bottomLeftLine = UIView(frame: .zero)
        addSubview(bottomLeftLine)
        bottomLeftLine.backgroundColor = .lineColor
        bottomLeftLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareCenterLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        let shareBtnWH :CGFloat = 44
        
        let friendsBtn = UIButton(frame: .zero)
        addSubview(friendsBtn)
        friendsBtn.setBackgroundImage(UIImage(named: "friends"), for: .normal)
        friendsBtn.layer.masksToBounds = true
        friendsBtn.layer.cornerRadius = shareBtnWH/2
        friendsBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLeftLine.snp.bottom).offset(15)
            make.height.width.equalTo(shareBtnWH)
            make.centerX.equalTo(self.snp.centerX)
        }
        mWechatCircleBtn = friendsBtn
        
        let wechatBtn = UIButton(frame: .zero)
        addSubview(wechatBtn)
        wechatBtn.setBackgroundImage(UIImage(named: "wechat"), for: .normal)
        wechatBtn.layer.masksToBounds = true
        wechatBtn.layer.cornerRadius = shareBtnWH/2
        wechatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLeftLine.snp.bottom).offset(15)
            make.height.width.equalTo(shareBtnWH)
            make.right.equalTo(friendsBtn.snp.left).offset(-30)
        }
        mWechatFriendsBtn = wechatBtn
        
        let weiboBtn = UIButton(frame: .zero)
        addSubview(weiboBtn)
        weiboBtn.setBackgroundImage(UIImage(named: "weibo"), for: .normal)
        weiboBtn.layer.masksToBounds = true
        weiboBtn.layer.cornerRadius = shareBtnWH/2
        weiboBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLeftLine.snp.bottom).offset(15)
            make.height.width.equalTo(shareBtnWH)
            make.left.equalTo(friendsBtn.snp.right).offset(30)
        }
        mWeiboBtn = weiboBtn

        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor(hexString: "#F8F8F8")
        addSubview(leftLineView)
        leftLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(wechatBtn.snp.bottom ).offset(15)
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        let hotCommentsLabel = UILabel(withText: "热门评论", fontSize: 16, color: .titleColor, numberOfLines: 1)
        addSubview(hotCommentsLabel!)
        hotCommentsLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(leftLineView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(kMarginLeft)
        })
        
        let moreContentsBtn = UIButton(title: "全部评论", img: nil, selectedImg: nil)
        addSubview(moreContentsBtn!)
        moreContentsBtn?.setTitleColor(.subtitleColor, for: .normal)
        moreContentsBtn?.titleLabel?.font = .subtitleFont
        moreContentsBtn?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(kMarginRight)
            make.top.equalTo(leftLineView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(20)
        })
        mAllCommentBtn = moreContentsBtn
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = .lineColor
        addSubview(seperatorLineView)
        seperatorLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
            make.top.equalTo(hotCommentsLabel?.snp.bottom ?? 0).offset(kMarginTop)
        }
        mBottomLine = seperatorLineView
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            mRegistered = true
            let webViewHeight: CGFloat = (contentLabel?.sizeThatFits(.zero).height)!
            // 默认是1, 加载完后肯定大于1
            if webViewHeight > 1.0.toCGFloat {
                contentLabel?.snp.updateConstraints({ (make) in
                    make.height.equalTo(webViewHeight)
                })

                if let block = mHeaderRefreshBlock {
                    // 每个() 代表一个元素  从上往下排列
                    // adImageViewHeight + 45 + mTitleLabelHeight + 25 + (15 + webViewHeight) + 35 + 25 + 15 + 45 + 30 + 25 + 20 + 16
                    let headerHeight = adImageViewHeight + mTitleLabelHeight + webViewHeight + 306

                    block(headerHeight)
                }
            }
        }
    }
    

    deinit {
        contentLabel?.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
}
