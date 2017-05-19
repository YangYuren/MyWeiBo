//
//  UserAccountTool.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/18.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    var account : UserAccount?
    var accountPath : String {
        //获取沙盒路径
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!//沙盒路径肯定有所以直接解包
        path = (path as NSString).strings(byAppendingPaths: ["account.plist"]).last!
        
        return path
    }
    //计算属性
    var isLogin : Bool {
        if account == nil{
            return false
        }
        guard let expires_date = account?.expires_date else {
            return false
        }
        return expires_date.compare(Date()) == ComparisonResult.orderedDescending
    }
    //重写init方法
    override init() {
        super.init()
        //读取信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
