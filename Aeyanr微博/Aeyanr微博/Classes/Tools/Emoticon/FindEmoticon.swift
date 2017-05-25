//
//  FindEmoticon.swift
//  正则表达式的测试
//
//  Created by Yang on 2017/5/25.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    static let shareInstance : FindEmoticon = FindEmoticon()
    //表情属性
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    //查找属性字符串的方法
    func findAttrString(statusText : String? , font : UIFont) -> NSMutableAttributedString?{
        //如果没有值返回空
        guard let statusText  = statusText else {
            return nil
        }
        //创建匹配规则
        let pattern = "\\[.*?\\]"  //
        guard let regex = try? NSRegularExpression(pattern :pattern ,options : []) else {
            return nil
        }
        //开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        //获得结果
        let attrMul = NSMutableAttributedString(string: statusText)
        if results.count != 0{
            let resultCount = results.count-1
            for  i in (0...resultCount).reversed() {
                //获取结果
                let result = results[i]
                //获取chs
                let chs = (statusText as NSString).substring(with: result.range)
                //根据chs获取图片路径
                guard let pngPath =  findPngPath(chs: chs) else {
                    return nil
                }
                //创建属性字符串
                let attachment = NSTextAttachment()
                attachment.image = UIImage(contentsOfFile: pngPath)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attrImageStr = NSAttributedString(attachment: attachment)
                //将属性字符串替换到源字符串中
                attrMul.replaceCharacters(in: result.range, with: attrImageStr)
            }
        }
        //返回结果
        return attrMul
    }
    fileprivate func findPngPath(chs : String) -> String?{
        for package in manager.packages{
            for emoticon in package.emoticons{
                if emoticon.chs == chs{
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
