//
//  NetWorkTools.swift
//  SwiftNetWorking
//
//  Created by Yang on 2017/5/16.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import AFNetworking
//定义枚举类型
enum RequestType {
    case GET,POST
}
class NetWorkTools: AFHTTPSessionManager {
    //let是线程安全的
    static let shareInstance : NetWorkTools = {//初始化可以填加闭包来实现一些初始化
        let tools = NetWorkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}
//MARK:- 封装请求方法
extension NetWorkTools {
    public func request(methodtype : RequestType ,urlString : String ,parameters:[String : Any] ,finished : @escaping (_ result : Any? , _ error : Error? )->()){
        //定义成功回调
        let successCallback = { (task : URLSessionDataTask, result : Any?) in
            finished(result,nil)
        }
        //定义失败回调
        let errorCallBack = { (task :URLSessionDataTask? , error : Error) in
            finished(nil,error)
        }
        //发送网路请求
        if(methodtype == .GET){
            get(urlString, parameters: parameters, progress: nil, success: successCallback, failure: errorCallBack)
        }else{
            post(urlString, parameters: parameters, progress: nil, success: successCallback, failure: errorCallBack)
        }
    }
}
//MARK:- 请求AccessToken
extension NetWorkTools{
    func loadAccessTools(code : String , finished : @escaping ( _ result : [String : Any]?, _ error : Error?)->()){
        //获取请求URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //获取请求参数
        let parameters = ["client_id" : app_key , "client_secret" : app_secret , "grant_type" : "authorization_code" , "code" : code , "redirect_uri" : redirect_uri]
        //发送网络请求
        request(methodtype: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any],error)
        }
    }
}
//MARK:- 请求用户信息
extension NetWorkTools {
    func loadUserInfo(access_token : String,uid : String ,finished : @escaping( _ result : [String : Any]?, _ error : Error?)->()){
        //获取请求URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        //获取请求参数
        let parameters = ["access_token" : access_token , "uid" : uid]
        //发送网络请求
        request(methodtype: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any] ,error)
        }
    }
}
//MARK:- 请求首页数据
extension NetWorkTools {
    func loadStatus(since_id : Int ,max_id : Int,finished : @escaping( _ result : [[String : Any]]? , _ error : Error?) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let accessToken = (UserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "since_id" : "\(since_id)","max_id" : "\(max_id)"]
        NetWorkTools.shareInstance.request(methodtype: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            //获取字典数据
            guard let resultDict = result as? [String : Any] else{
                finished(nil, error)
                return
            }
            //将数组数据回调给外界
            finished(resultDict["statuses"] as? [[String : Any]], error)
        }
    }
}
//MARK:- 发送微博
extension NetWorkTools {
    func sendWeibo(statusText : String , isSuccess : @escaping( _ isSuccess : Bool) -> ()){
        //请求的urlString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //获取请求参数列表
        let accessToken = (UserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "status" : statusText]
        request(methodtype: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSuccess(true)
            }else{
                isSuccess(false)
            }
        }
    }
}
//MARK:- 发送微博携带照片
extension NetWorkTools {
    func senPicWeibo(statusText : String ,image : UIImage, isSuccess : @escaping( _ isSuccess : Bool) -> ()){
        //请求的urlString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        //获取参数
        let accessToken = (UserAccountViewModel.shareInstance.account?.access_token)!
        let parameters = ["access_token" : accessToken, "status" : statusText]
        NetWorkTools.shareInstance.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                //name属性不能随便写  必须与请求参数保持一致
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { ( _, _) in
            isSuccess(true)
        }) { ( _, error ) in
            print(error)
        }
    }
}







