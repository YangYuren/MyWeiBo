//
//  UserAccount.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/17.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

/*
 "access_token": "ACCESS_TOKEN",
 "expires_in": 1234,
 "remind_in":"798114",
 "uid":"12341234"
 */
class UserAccount: NSObject,NSCoding {
    //授权accessToken
    var access_token : String?
    //过期时间（秒）
    var expires_in : TimeInterval = 0.0 {
        didSet{
            expires_date  = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //用户ID
    var uid : String?
    //过期日期
    var expires_date : Date?
    //昵称
    var screen_name : String?
    //用户头像
    var avatar_large : String?
    //自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    //键名不够时候重写该方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    //重写description属性
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
    //MARK:-解档方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as! String
        uid = aDecoder.decodeObject(forKey: "uid") as! String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as! Date
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as! String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as! String
    }
    //归档方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}

