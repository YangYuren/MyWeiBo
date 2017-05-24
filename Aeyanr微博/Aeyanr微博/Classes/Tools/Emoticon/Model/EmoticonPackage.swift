//
//  EmoticonPackage.swift
//  textView测试
//
//  Created by Yang on 2017/5/23.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emoticons : [Emoticon] = [Emoticon]()
    init(id : String) {
        super.init()
        //最近
        if id == ""{
            addEmptyEmoticon(isRecently: true)
            return
        }
        //根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //根据plist文件路径读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        //遍历数组
        var index : Int = 0
        for var dict in array{
            if let png = dict["png"]{
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index += 1
            if index == 20 {
                //添加删除表情
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        //添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    fileprivate func addEmptyEmoticon(isRecently : Bool){
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20{
            //添加空表表情
            emoticons.append(Emoticon(isEmpty: true))
        }//添加删除表情
        emoticons.append(Emoticon(isRemove: true))
    }
}
