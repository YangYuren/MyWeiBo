//
//  UIBarButtonItem-Extension.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/14.
//  Copyright © 2017年 Yang. All rights reserved.
//

import Foundation
import UIKit
extension UIBarButtonItem {
    convenience init(imageName : String) {
        self.init()
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named:imageName), for: .normal)
        leftBtn.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted)
        leftBtn.sizeToFit()
        self.customView = leftBtn
        //self.init(customView: leftBtn)  //与上面效果一样
    }
}
