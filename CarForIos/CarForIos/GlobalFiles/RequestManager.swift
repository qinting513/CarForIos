//
//  RequestManager.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/15.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/** 默认请求参数 */
let kPageSize = 10

class RequestManager: NSObject {
    
    static let shared = RequestManager()
    
    func cancelTaskWithFlag(flag:Int)  {
        
    }
    
    
    func Post(URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        var token: String = ""
        if (UserInfo.current.token != nil) {
            token = UserInfo.current.token!
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "",
            "Content-Type": "application/json"
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowString = formatter.string(from: Date())

        
        let RequestParameters = [
            "method": URLString,
            "timestamp": nowString,
            "version": "1.0",
            "token": token ,
            "biz_content": parameters ?? [:]
            ] as [String : Any]
        
        Alamofire.request(BaseURLStr, method: .post, parameters: RequestParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            debugPrint("----------------- Request Start ---------------------------")
            debugPrint("Request_URL:" + BaseURLStr)
            debugPrint("Request_Params:\(RequestParameters)")
            debugPrint("Request_Response:")
            debugPrint(JSON(response.result.value ?? "NoValue"))
            debugPrint("----------------- Request End ---------------------------")
            
            // 3.获取结果
            guard let resultValue = response.result.value else {
                debugPrint(response.result.error!)
                finishedCallback("")
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(resultValue)
        }
        
    }
    
    func update(_ URLString : String, parameters : [String : Any]? = nil, image: UIImage, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        //先把图片转成NSData
        let imageData: Data = UIImageJPEGRepresentation(image, 0.5)!
        
        Alamofire.upload(multipartFormData: { (formData) in
            //拼接上传文件的二进制数据
            formData.append(imageData, withName: "avatar", fileName: "avatar"+".jpeg", mimeType: "image/jpeg")
            
            //遍历参数字典，生产对应的参数数据
            if let par = parameters {
                for (key,value) in par {
                    let str = value as! String
                    //把字符串编码成二进制文件
                    let strData = str.data(using: .utf8)
                    //拼接二进制数据
                    formData.append(strData!, withName: key)
                }
            }

        }, to: URL(string: URLString)!) { (encodingResult) in
            switch encodingResult {
                case .success(let request, _, _):
                    request.responseJSON(completionHandler: { (response) in
                        // 3.获取结果
                        guard let resultValue = response.result.value else {
                            print(response.result.error!)
                            finishedCallback("")
                            return
                        }
                    
                        // 4.将结果回调出去
                        finishedCallback(resultValue)
                })
            case .failure(let error ):
                print(error)
                finishedCallback("")
            }
        }
    }
    

    
    /** 错误处理 */
    func hanedleRequestErrorWith(json:JSON) {
        let code = json["code"].stringValue
        let msg  = json["msg"].stringValue
        
        if code == "0000" {
            return
        } else {
            print(msg)
        }
    }
}

