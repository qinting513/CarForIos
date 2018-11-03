//
//  AppDelegate.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/10.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON


let Key_Wechat = "wxa5886e92864ade98"
let sinaWeiboAppKey = "2509407798"
let sinaWeiboAppSecret = "4280cbdce73789c0fbba753fe6be4a59"
let sinaOredirectURL = "https://weibo.com"

// 分享 APP 需要的东西
let kShareAppDes = "顽车的人更懂车，懂车的人是顽家"
let kShareAppTitle = "顽家"
let kShareAppImageName = "AppIcon"
let kAppDownloadUrl = "http://car.demo.chilunyc.com/page/static/app.html"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
  
    static let shared = AppDelegate()
    
    var window: UIWindow?
    
    /// 是否显示了广告图
    var mIsShowedAd = false
    
    let menuView = MenuView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight))
    var currentSelectIndex : Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        launchAppImage()
        
        WXApi.registerApp(Key_Wechat)
        
        /// https://segmentfault.com/a/1190000004621065
        // 是否开启Debug模式, 开启后会打印错误信息, 开发期建议开启
        LDSinaShare.registeApp(sinaWeiboAppKey, appSecret: sinaWeiboAppSecret, oredirectUri: sinaOredirectURL, isDebug: true)
        
        loadStandUser()
        
        buildKeyWindow()
        
        // 注册设备旋转通知
        orientationNotic()
        
        return true
    }
    
    func launchAppImage() {
        window? = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ADViewController()
        window?.makeKeyAndVisible()

    }

    func loadStandUser() {
        if UserDefaults.standard.bool(forKey: Key_ISLogined) {
            if let jsonDic:[String : Any] = UserDefaults.standard.value(forKey: Key_UserInfoJson) as? [String : Any] {
                UserInfo.current.initWith(json: JSON(jsonDic))
                print("本地已经缓存了用户数据: \n UserToken: \(UserInfo.current.token!)")
            }
        }
        
    }
    
    public func buildKeyWindow() {
        
        
        guard mIsShowedAd else {
            launchAppImage()
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController = HomeNavigationController(rootViewController: HomeViewController())
        
        self.setupFloatingButton()
        UIApplication.shared.keyWindow?.addSubview(AssistiveBtn.shared)
    }
 
    
   func setupFloatingButton(){
        let floatingButton = AssistiveBtn.shared
        floatingButton.mHaveNewMsg = false
        floatingButton.addTarget(self, action: #selector(floatingButtonClick), for: .touchUpInside)
        /** 可能同时也添加的手势识别UIGestureRecognizer，已经判断为手势了。
         把这个添加上去试试，当判断为手势后，就不走 touchesEnded，走touchesCancelled了。 */
        //let pan = UIPanGestureRecognizer.init(target: self, action: #selector(changePosition))
        //floatingButton.addGestureRecognizer(pan)
    }
    
    func orientationNotic() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationNoticAction), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func orientationNoticAction(noti: Notification) {
        let device = UIDevice.current
        switch (device.orientation) {
            //屏幕幕朝上平躺
            case .faceUp:
                print("屏幕幕朝上平躺");
                break;
            //屏幕朝下平躺
            case .faceDown:
                print("屏幕朝下平躺");
                break;
            
            //系统当前无法识别设备朝向，可能是倾斜
            case .unknown:
                print("未知方向");
                break;
            
            //屏幕向左橫置
            case .landscapeLeft:
                print("屏幕向左橫置");
                break;
            
            //屏幕向右橫置
            case .landscapeRight:
                print("屏幕向右橫置");
                break;
            
            //屏幕直立
            case .portrait:
                print("屏幕直立");
                break;
            
            //屏幕直立，上下顛倒
            case .portraitUpsideDown:
                print("屏幕直立，上下顛倒");
                break;
        }
    }
    
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CarForIos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Wechat -
    // 新浪微博的H5网页登录回调需要实现这个方法
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        // 这里的URL Schemes是配置在 info -> URL types中, 添加的新浪微博的URL schemes
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        if url.scheme == "wb2509407798" {
            // 新浪微博 的回调
            return LDSinaShare.handle(url)
        }
        
        let urlKey: String = sourceApplication ?? ""
        if urlKey == "com.sina.weibo" {
            // 新浪微博 的回调
            return LDSinaShare.handle(url)
        }else{
            WXApi.handleOpen(url, delegate: self)
        }

        return true
    }
    
    // NS_DEPRECATED_IOS(2_0, 9_0)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        if urlKey == "com.sina.weibo" {
            // 新浪微博 的回调
            return LDSinaShare.handle(url)
        }else{
           WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }

    // MARK: - 微信登录回调 -
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。
    //第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    func onReq(_ req: BaseReq!) {
        print(req.type)
    }
    
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: SendAuthResp.self) {
            if let response = resp as? SendAuthResp {
                if let code = response.code {
                    NotificationCenter.default.post(name: Notification.Name(kWechatLoginDidSuccess), object: self, userInfo: ["code": code])
                    return
                }
            }
        }
        
    }
}

extension AppDelegate {
    
}

