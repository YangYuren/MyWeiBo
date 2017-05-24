//
//  Emoticon.swift
//  textView测试
//
//  Created by Yang on 2017/5/23.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    //MARK:- 定义属性
    var code : String?{  //emoji的code
        didSet{
            guard let code = code else {//为空直接返回
                return
            }
            //创建一个扫描器
            let scanner = Scanner(string: code)
            //扫描吃code中得值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            //将value转成字符串
            let c = Character(UnicodeScalar(value)!)
            //将字符转为字符串
            emojiCode = String(c)
        }
    }
    var png : String?{//普通表情对应的图片名称
        didSet{
            guard let png = png else {//为空直接返回
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?   //普通表情对应的文字
    //MARK:- 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    //MARK:- 自定义构造函数
    init(dict : [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    //记录删除表情 
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    //记录空白表情
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    //kVC赋值
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String{
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
}
