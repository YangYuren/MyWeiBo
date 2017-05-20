//
//  Status.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/18.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class Status: NSObject {
    var created_at : String? //微博创建时间
    var source : String?   //微博来源
    var text : String?  //微博正文
    var mid : Int = 0   //微博id
    var user : User?    //用户信息
    var pic_urls : [[String : String]]? 
    //自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        if let userDict = dict["user"] as? [String : Any] {
            user = User(dict: userDict)
        }
        
    }
    //键名不够时候重写该方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
