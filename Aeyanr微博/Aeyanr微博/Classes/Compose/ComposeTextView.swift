//
//  ComposeTextView.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/22.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {
    lazy var placeHolderlabel : UILabel = UILabel()
    //构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
//设置UI界面
extension ComposeTextView{
    fileprivate func setupUI(){
        //添加子空间
        addSubview(placeHolderlabel)
        placeHolderlabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //设置属性
        placeHolderlabel.textColor = UIColor.lightGray
        placeHolderlabel.font = font
        //设置文字
        placeHolderlabel.text = "分享新鲜事情...."
        //设置内容内边距
        textContainerInset = UIEdgeInsets(top: self.textContainerInset.top, left: 7, bottom: 0, right: 7)
    }
}
