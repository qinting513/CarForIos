//
//  MineDetailViewController.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/21.
//  Copyright © 2018年 chilunyc. All rights reserved.
//

import UIKit
import SwiftyJSON
import RSKImageCropper

class MineDetailViewController: UITableViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var wechatSwitch: UISwitch!
    @IBOutlet weak var weiboSwitch: UISwitch!
    
    var mHeaderBtn: UIImageView?
    
    @IBAction func wechatSwitchClick(_ sender: UISwitch) {
    
    }
    
    @IBAction func weiboSwitchClick(_ sender: UISwitch) {
    
    }
    
    lazy var headerView : UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 150))
        self.view.addSubview(headerView)
        headerView.backgroundColor = .backgroundColor
        
        let avatarBtn = UIImageView(image: .defaultHeader)
        headerView.addSubview(avatarBtn)
        avatarBtn.isUserInteractionEnabled = true
        avatarBtn.addTapGesture(target: self, action: #selector(avatarBtnClick))
        avatarBtn.setImage(with: URL(string: UserInfo.current.avatar ?? ""), placeHolder: .defaultHeader)
        avatarBtn.setCornerRadius(radius: 40)
        let avatarBtnWH :CGFloat = 80.0
        avatarBtn.snp.makeConstraints({(make) in
            make.width.equalTo(avatarBtnWH)
            make.height.equalTo(avatarBtnWH)
            make.center.equalToSuperview()
        })
        mHeaderBtn = avatarBtn
        
        let cameraIMG = UIButton()
        cameraIMG.setImage(UIImage(named: "IMG_Take_Photo"), for: .normal)
        cameraIMG.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        cameraIMG.setBackgroundImage(UIImage(named: "IMG_Take_Phone_bg"), for: .normal)
        cameraIMG.layer.masksToBounds = true
        cameraIMG.layer.cornerRadius = 10
        cameraIMG.addTapGesture(target: self, action: #selector(avatarBtnClick))
        headerView.addSubview(cameraIMG)
        cameraIMG.snp.makeConstraints({ (make) in
            make.bottom.right.equalTo(avatarBtn)
            make.width.height.equalTo(20)
        })
        
        return headerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人资料"
        tableView.rowHeight = 50
        tableView.backgroundColor = .backgroundColor
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView
        
        nameLabel.text = UserInfo.current.nickname ?? ""
        phoneLabel.text = UserInfo.current.mobile ?? ""
        if  let isOn = UserInfo.current.bind_account3?.contains("WEIBO") {
            weiboSwitch.isOn = isOn
        }
        
        if  let isOn = UserInfo.current.bind_account3?.contains("WX") {
            wechatSwitch.isOn = isOn
        }
        
        wechatSwitch.addTarget(self, action: #selector(wechatSwitchAction), for: .touchUpInside)
        weiboSwitch.addTarget(self, action: #selector(weiboSwitchAction), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(wechatLoginSuccess), name: Notification.Name(kWechatLoginDidSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(weiboLoginSuccess), name: Notification.Name(kWeiboLoginDidSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(weiboLoginFaild), name: Notification.Name(kWeiboLoginDidFaild), object: nil)
    }
 
    @objc func weiboSwitchAction(sender: UISwitch) {
        if sender.isOn {
            bindAction(with: .weibo)
        } else {
            confirmAlirt(with: .weibo)
        }
    }
    
    @objc func wechatSwitchAction(sender: UISwitch) {
        if sender.isOn {
            bindAction(with: .wechat)
        } else {
            confirmAlirt(with: .wechat)
        }
    }
    
    // 解绑第三方
    func unBindAction(with type: ThirdType){
        let params = [
            "type": type == .wechat ? "WX" : "WEIBO"
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_Unbind, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                self?.showSuccess(with: "解绑成功")
                if type == .weibo {
                    self?.weiboSwitch.setOn(false, animated: true)
                } else {
                    self?.wechatSwitch.setOn(false, animated: true)
                }
            } else {
                self?.showError(with: "解绑失败, 请稍后再试")
            }
        }
    }
    
    // 绑定第三方
    func bindAction(with type: ThirdType){
        if type == .weibo {
            weiboSwitch.setOn(false, animated: true)
            let request = WBAuthorizeRequest()
            request.scope = "all"
            request.redirectURI = "https://weibo.com"
            WeiboSDK.send(request)
        } else {
            wechatSwitch.setOn(false, animated: true)
            if WXApi.isWXAppInstalled() {
                let req = SendAuthReq()
                req.scope = "snsapi_userinfo"
                req.state = "App"
                WXApi.send(req)
            }
        }
    }
    
    @objc func wechatLoginSuccess(noti: Notification) {
        let code = noti.userInfo!["code"] as! String
        let params = [
            "type": "WX",
            "code": code,
            "client_type": "IOS",
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_UserBind, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 获取 token, 如果 token 存在, 说明登录成功
                let userToken = result["rsp_content"]["token"].stringValue
                if userToken.length > 1 {
                    UserDefaults.standard.set(true, forKey: Key_ISLogined)
                    UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                    UserInfo.current.initWith(json: result["rsp_content"])
                    self?.showSuccess(with: "绑定成功")
                    self?.wechatSwitch.setOn(true, animated: true)
                }
            } else {
                self?.showError(with: "微信授权失败")
                self?.wechatSwitch.setOn(false, animated: true)
            }
        }
    }
    
    @objc func weiboLoginSuccess(noti: Notification) {
        let access = noti.userInfo!["access"] as! String
        let uid = noti.userInfo!["uid"] as! String
        
        let params = [
            "type": "WEIBO",
            "access_token": access,
            "client_type": "IOS",
            "uid": uid
            ] as [String : Any]
        
        RequestManager.shared.Post(URLString: URL_UserBind, parameters: params) { [weak self] (resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 获取 token, 如果 token 存在, 说明登录成功
                let userToken = result["rsp_content"]["token"].stringValue
                if userToken.length > 1 {
                    UserDefaults.standard.set(true, forKey: Key_ISLogined)
                    UserDefaults.standard.set(result["rsp_content"].dictionaryObject, forKey: Key_UserInfoJson)
                    UserInfo.current.initWith(json: result["rsp_content"])
                    self?.showSuccess(with: "绑定成功")
                    self?.weiboSwitch.setOn(true, animated: true)
                }
            } else {
                self?.weiboSwitch.setOn(false, animated: true)
                self?.showError(with: "微博授权失败")
            }
        }
    }
    
    // 微博登录失败, 包括用户取消登录, 授权失败
    @objc func weiboLoginFaild() {
        showError(with: "微博授权失败")
        weiboSwitch.setOn(false, animated: true)
    }
    
    @objc func avatarBtnClick(){
        
        let sheet = UIAlertController(title: "请选择图片来源", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "图库", style: .default, handler: { [weak self](artion) in
            self?.takePictureFromGallery()
        }))
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { [weak self](ation) in
            self?.takePictureFromCamera()
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler:  nil))
        presentVC(sheet)
    }
    
    // 获取相册里的图片
    func takePictureFromGallery() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        presentVC(imgPicker)
    }
    
    //获取相机中的照片
    func takePictureFromCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showError(with: "当前设备部支持拍照")
            return
        }
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self;
        imgPicker.sourceType = .camera
        presentVC(imgPicker)
    }
    
    func confirmAlirt(with type: ThirdType) {
        let thirdName = type == .weibo ? "微博" : "微信"
        let alertController = UIAlertController(title: "温馨提示",message: "确定要解绑\(thirdName)吗, 解绑后您将不能使用\(thirdName)登录", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:{ [weak self]
            action in
            if type == .weibo {
                self?.weiboSwitch.setOn(true, animated: true)
            } else {
                self?.wechatSwitch.setOn(true, animated: true)
            }
        })
        let okAction = UIAlertAction(title: "解绑", style: .default, handler: { [weak self]
            action in
            self?.unBindAction(with: type)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MineDetailViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if  indexPath.row == 0 {
                let vc = UIStoryboard.mainStoryboard?.instantiateViewController(withIdentifier: "ChangeNameViewController") as? ChangeNameViewController
                vc?.changeNameCallBack = { (name) in
                        self.nameLabel.text = name
                }
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                
                let vc = VerifyTellViewController()
                vc.title = "验证手机号"
                pushVC(vc)
            }
          
        }
    }
}


extension MineDetailViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismissVC(completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                let imageCrpVC = RSKImageCropViewController(image: image)
                imageCrpVC.delegate = self
                self?.pushVC(imageCrpVC)
            }
        }
    }
}

extension MineDetailViewController: RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        updateAvator(with: croppedImage)
        controller.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let aspectRatio = CGSize(width: 16.0, height: 9.0)
        let viewWidth: CGFloat = controller.view.frame.width
        let viewHeight:CGFloat = controller.view.frame.height
        var maskWidth: CGFloat
        if controller.isPortraitInterfaceOrientation() {// isPortraitInterfaceOrientation]) {
            maskWidth = viewWidth
        } else {
            maskWidth = viewHeight
        }
        
        var maskHeight: CGFloat
        repeat {
            maskHeight = maskWidth * aspectRatio.height / aspectRatio.width;
            maskWidth -= 1.0
        } while (maskHeight != floor(maskHeight));
        
        maskWidth += 1.0
        let maskSize = CGSize(width: maskWidth, height: maskHeight)
        
        let maskRect = CGRect(x:(viewWidth - maskSize.width) * 0.5,
                              y:(viewHeight - maskSize.height) * 0.5,
                              w:maskSize.width,
                              h:maskSize.height);
        
        return maskRect;
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        let point1: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let point2: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let point3: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let point4: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let rectangle = UIBezierPath()
        rectangle.move(to: point1)
        rectangle.addLine(to: point2)
        rectangle.addLine(to: point3)
        rectangle.addLine(to: point4)
        rectangle.close()
        
        return rectangle
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        if controller.rotationAngle == 0 {
            return controller.maskRect
        } else {
            let maskRect: CGRect = controller.maskRect
            let rotationAngle: CGFloat = controller.rotationAngle
            
            var movementRect: CGRect = .zero
        
            movementRect.size.width = maskRect.width * fabs(cos(rotationAngle)) + maskRect.height * fabs(sin(rotationAngle))
            movementRect.size.height = maskRect.height * fabs(cos(rotationAngle)) + maskRect.width * fabs(sin(rotationAngle))
            
            movementRect.origin.x = maskRect.minX + (maskRect.width - movementRect.width) * 0.5
            movementRect.origin.y = maskRect.minY + (maskRect.height - movementRect.height) * 0.5

            movementRect.origin.x = floor(movementRect.minX)
            movementRect.origin.y = floor(movementRect.minY)
            movementRect = movementRect.integral
            
            return movementRect
        }
    }
    
    // MARK: - 上传头像 -
    func updateAvator(with image: UIImage) {
        
        let headerImage = image.scaled(to: CGSize(width: 200, height: 200))
        
        let params = [
            "type": "userhead",
            ] as [String : Any]
        RequestManager.shared.update(URL_FileUpload, parameters: params, image: headerImage) { [weak self](resultValue) in
            let result = JSON(resultValue)
            
            // 上传图片成功, 拿着图片的 id 再请求更新用户信息接口
            if result["code"].intValue == 0 {
                if let file_id = result["items"][0]["file_id"].string {
                    self?.updateUserInfo(file_id: file_id)
                    self?.mHeaderBtn?.image = headerImage
                    return
                }
                self?.showError(with: "上传用户头像失败, 请稍后再试")
                return
            }
            self?.hidenLoading()
            self?.showError(with: "上传用户头像失败, 请稍后再试")
        }
    }
    
    func updateUserInfo(file_id: String) {
        let params = [
            "avatar": file_id,
            "nickname": UserInfo.current.nickname ?? ""
            ] as [String : Any]
        RequestManager.shared.Post(URLString: URL_Update, parameters: params) { [weak self](resultValue) in
            let result = JSON(resultValue)
            if result["sub_code"].stringValue == "SUCCESS" {
                // 更新用户信息
                UserInfo.current.initWith(json: result["rsp_content"])
                self?.hidenLoading()
            } else {
                self?.hidenLoading()
            }
        }
    }
    
    
}
