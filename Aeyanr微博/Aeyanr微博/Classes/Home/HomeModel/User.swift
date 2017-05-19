//
//  User.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/19.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class User: NSObject {
    //MARK:- 属性
    var profile_image_url : String? //用户头像
    var screen_name : String?   //用户昵称
    var verified_type : Int = -1    //用户认证类型
    var mbrank : Int = 0    //用户会员等级
    //初始化
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    //键名不够时候重写该方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
