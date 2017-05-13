//
//  UIButton-Extension.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    //MARK:- 创建自定义按钮
    /*class func createButton(imageName : String , bgImageName : String) -> UIButton{
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage(named:bgImageName+"t_highlighted"), for: .highlighted)
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }*/
    //遍历构造函数通常用在对系统的类进行构造函数的扩充时候使用
     convenience init (imageName : String , bgImageName : String) {
        self.init()
        self.setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        self.setBackgroundImage(UIImage(named:bgImageName+"t_highlighted"), for: .highlighted)
        self.setImage(UIImage(named:imageName), for: .normal)
        self.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        self.sizeToFit()
    }
}
