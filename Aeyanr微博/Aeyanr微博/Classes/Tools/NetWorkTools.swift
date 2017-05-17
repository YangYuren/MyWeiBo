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
