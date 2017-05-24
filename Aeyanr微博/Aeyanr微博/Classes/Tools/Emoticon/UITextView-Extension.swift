//
//  UIself-Extension.swift
//  self测试
//
//  Created by Yang on 2017/5/24.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

extension UITextView {
    //给textView插入字符串
    func insertEmoticon(emoticon : Emoticon) {
        //点击空白表情
        if emoticon.isEmpty {
            return
        }
        //删除按钮
        if emoticon.isRemove {
            self.deleteBackward()//删除字符
            return
        }
        //emoji表情
        if emoticon.emojiCode != nil {
            //获取光标位置
            let textRange = self.selectedTextRange!
            //插入光标后面
            self.replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        //普通表情
        //图文混排,根据图片路径创建属性字符串
        let attacment = EmoticonTextAttachment()
        attacment.chs = emoticon.chs
        attacment.image = UIImage(named: emoticon.pngPath!)
        let font = self.font
        attacment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let attrImage = NSAttributedString(attachment: attacment)
        //创建可变属性字符串
        let attrMul = NSMutableAttributedString(attributedString: self.attributedText)
        //将图片可变字符串替换到可变字符串
        //获取光标位置
        let textRange = self.selectedRange
        attrMul.replaceCharacters(in: textRange, with: attrImage)
        //显示属性字符串
        self.attributedText = attrMul
        //将文字大小重置回去
        self.font = font
        //将光标设置到原来位置 + 1
        self.selectedRange = NSRange(location: textRange.location + 1, length: 0)
    }
    func getEmoticonString() -> String{
        //获取属性字符串
        let attrMul = NSMutableAttributedString(attributedString: self.attributedText)
        //比那里属性字符串
        let range = NSRange(location: 0, length: attrMul.length)
        attrMul.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if  let attch = dict["NSAttachment"] as? EmoticonTextAttachment {
                attrMul.replaceCharacters(in: range, with: attch.chs!)
            }
        }
        //获取字符串
        return attrMul.string
    }
}
