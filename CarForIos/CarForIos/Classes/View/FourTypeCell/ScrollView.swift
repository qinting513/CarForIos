//
//  ScrollView.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/12.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import FSPagerView
import SwiftRichString

typealias kBannerDidClickBlock = (_ item: BannerModel) -> ()

class ScrollView: UIView {
    
    var mBannerClickBlock: kBannerDidClickBlock?

   lazy var pagerView : FSPagerView = {
        let pagerView = FSPagerView()
            pagerView.frame = CGRect(x: 0, y: 0, w: self.bounds.size.width, h: self.bounds.size.height - 15)
            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.itemSize = .zero
            pagerView.isInfinite = true
            pagerView.automaticSlidingInterval = 3.0
            pagerView.removesInfiniteLoopForSingleItem = true
            pagerView.register(CustomFSPageViewCell.self, forCellWithReuseIdentifier: CustomFSPageViewCell.className())
      return pagerView
    }()
    
   lazy var pageControl : FSPageControl = {
        let pageControl = FSPageControl()
            pageControl.frame = CGRect(x: 0, y: self.frame.size.height - 20,
                                       width: kScreenWidth, height: 20)
            pageControl.contentHorizontalAlignment = .center
            pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return pageControl
    }()
    
    /// 上一张
    lazy var preBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "IMG_Go_Pre"), for: .normal)
        btn.addTarget(self, action: #selector(preBtnDidClick), for: .touchUpInside)
        btn.frame = CGRect(x: 15, y: (self.frame.size.height / 2) - 22 , w: 22, h: 22)
        return btn
    }()
    
    /// 下一张
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "IMG_Go_Nex"), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnDidClick), for: .touchUpInside)
        btn.frame = CGRect(x: self.frame.size.width-37, y: (self.frame.size.height / 2) - 22 , w: 22, h: 22)
        return btn
    }()
    
    /// 数据源
    var items = [BannerModel](){
        didSet{
            if items.count == 0 {
                self.mj_h = 0
            }
            
            /// 只有一个的时候不显示上下页按钮
            if items.count == 1 {
                preBtn.isHidden = true
                nextBtn.isHidden = true
            }
            /// 大于1的时候, 默认第一张, 不显示上一张按钮
            if items.count > 1 {
                preBtn.isHidden = true
                nextBtn.isHidden = false
            }
            
            
            
            pagerView.reloadData()
            self.pageControl.numberOfPages = items.count
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGB(r: 248, g: 248, b: 248)
        addSubview(pagerView)
        addSubview(preBtn)
        addSubview(nextBtn)
        //self.addSubview(pageControl)
        pagerView.dataSource = self
        pagerView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 上一张
    @objc func preBtnDidClick() {
        let index = pagerView.currentIndex
        print("pagerView.currentIndex: \(pagerView.currentIndex)")
        if index == 0 {
            pagerView.deselectItem(at: items.count-1, animated: true)
            pagerView.scrollToItem(at: items.count-1, animated: true)
        }
        
        else {
            pagerView.deselectItem(at: index-1, animated: true)
            pagerView.scrollToItem(at: index-1, animated: true)
        }
    }
    
    /// 下一张
    @objc func nextBtnDidClick() {
        print("pagerView.currentIndex: \(pagerView.currentIndex)")
        let index = pagerView.currentIndex
        if index < items.count-1 {
            pagerView.deselectItem(at: index+1, animated: true)
            pagerView.scrollToItem(at: index+1, animated: true)
        }
            
        else {
            pagerView.deselectItem(at: 0, animated: true)
            pagerView.scrollToItem(at: 0, animated: true)
        }
    }
}

extension ScrollView :FSPagerViewDataSource, FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.items.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CustomFSPageViewCell.className(), at: index) as! CustomFSPageViewCell
        
        let url = self.items[index].image_url
        if (url != nil) {
            cell.mImageView?.setImage(with: URL(string: url!))
        } else {
            cell.mImageView?.image = UIImage(named: "DefaultNoData")
        }
        
        cell.mDesLabel?.text = items[index].title
        cell.mDesLabel?.font = SystemFonts.PingFangSC_Regular.font(size: 18)

        cell.mImageView?.contentMode = .scaleAspectFill
        cell.mImageView?.clipsToBounds = true
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
        if (mBannerClickBlock != nil) {
            mBannerClickBlock!(items[index])
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        
        preBtn.isHidden = pagerView.currentIndex == 0
        nextBtn.isHidden = pagerView.currentIndex == items.count-1
        
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
}

class CustomFSPageViewCell: FSPagerViewCell {
    
    var mImageView: UIImageView?
    
    var mLabelCover: UIView?
    
    var mDesLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "DefaultNoData"))
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mImageView = imageView
        
        let desLabelBgView = UIView()
        desLabelBgView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.6)
        contentView.addSubview(desLabelBgView)
        desLabelBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = SystemFonts.PingFangSC_Regular.font(size: 18)
        desLabelBgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.height.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(kMarginRight)
        }
        mDesLabel = titleLabel
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
