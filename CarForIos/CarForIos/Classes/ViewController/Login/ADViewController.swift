//
//  ADViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/9/2.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON

class ADViewController: UIViewController {

    var mImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "LaunchImageCopy"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mImageView = imageView
        
        
        let params = ["client_type": "IOS"]
        RequestManager.shared.Post(URLString: URL_AppInfo, parameters: params) { (resultValue) in
            let result = JSON(resultValue)
            print(result)
            if result["sub_code"].stringValue == "SUCCESS" {
                AppInfo.shared.initWith(json: result["rsp_content"])
                imageView.setImage(with: URL(string: AppInfo.shared.launch_img_url!), placeHolder: nil)
            } else {
                AppDelegate.shared.mIsShowedAd = true
                AppDelegate.shared.buildKeyWindow()
            }
        }
        
        delay(2) {
            AppDelegate.shared.mIsShowedAd = true
            AppDelegate.shared.buildKeyWindow()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
