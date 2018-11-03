//
//  ItemsCell.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/14.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import YYKit

class ItemsCell: UITableViewCell {

    var collectionView : UICollectionView?
    
    var mTitleLabel : UILabel?
    
    var mDelegate : ItemCellCollectionItemDidSelected?
    
   
    var articles: [HomeModel?] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    //MARK: - setupUI
    func setupUI(){
        
        contentView.backgroundColor = .white
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(hexString: "#F8F8F8")
        self.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        let titleLeftImg = UIView()
        titleLeftImg.backgroundColor = .mainColor
        titleLeftImg.setCornerRadius(radius: 1.5)
        contentView.addSubview(titleLeftImg)
        titleLeftImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginLeft)
            make.height.equalTo(20)
            make.width.equalTo(3)
            make.top.equalTo(seperatorView.snp.bottom).offset(kMarginTop)
        }
        

        let title = "板块标题"
        let titleLabel = UILabel(withText:title , fontSize: 16, color: UIColor.black,numberOfLines:1)
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(seperatorView.snp.bottom).offset(kMarginTop)
            make.left.equalTo(titleLeftImg.snp.right).offset(kMarginLeft)
            make.right.equalToSuperview().offset(kMarginRight)
            make.height.equalTo(20)
        }
        mTitleLabel = titleLabel
        
        let lineVIew = UIView()
        lineVIew.backgroundColor = .clear
        contentView.addSubview(lineVIew)
        lineVIew.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(titleLabel?.snp.bottom ?? 0).offset(kMarginTop)
        }
        
        //创建布局对象
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 230, height: 110 + 89)
        flowLayout.scrollDirection = .horizontal
        //设置分区缩进量
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7.5)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .white
        collectionView?.register(OneItemCollectionViewCell.self, forCellWithReuseIdentifier: "OneItemCollectionViewCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalTo(lineVIew.snp.bottom)//.offset(kMarginTop)
            make.left.equalToSuperview().offset(kMargin)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hexString: "#F8F8F8")
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ItemsCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return articles.count
    }
    
    //返回一个分区有多少个Item的方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //返回UICollectionViewCell视图
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneItemCollectionViewCell", for: indexPath) as? OneItemCollectionViewCell
        cell?.setupModel(model: articles[indexPath.section], indexPathRow: indexPath.row, isKnow: false)
        return cell ?? UICollectionViewCell()
    }
}

extension ItemsCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mDelegate?.collectionItemClick(article: articles[indexPath.row])
    }
}

protocol ItemCellCollectionItemDidSelected {
    func collectionItemClick(article: HomeModel?)
}
