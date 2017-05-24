//
//  EmoticonManager.swift
//  textView测试
//
//  Created by Yang on 2017/5/23.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class EmoticonManager{
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    init() {
        //添加最近标表情包
        packages.append(EmoticonPackage(id : ""))
        //默认
        packages.append(EmoticonPackage(id : "com.sina.default"))
        //emoji
        packages.append(EmoticonPackage(id : "com.apple.emoji"))
        //浪小花
        packages.append(EmoticonPackage(id : "com.sina.lxh"))
    }
}
