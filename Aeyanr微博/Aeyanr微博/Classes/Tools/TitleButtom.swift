//
//  TitleButtom.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/14.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class TitleButtom: UIButton {
    //MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame:frame)
        setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重新布局控件
    override func layoutSubviews() {
        super.layoutSubviews()
        //swift中可以直接修改对象结构体中的属性
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 8
    }
    //swift中取消高亮状态
    override var isHighlighted: Bool {
        set{
            
        }
        get {
            return false
        }
    }
}
