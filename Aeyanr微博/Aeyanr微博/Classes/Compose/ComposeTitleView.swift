//
//  ComposeTitleView.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/22.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {
    //标题名字
    fileprivate lazy var titleLabel  : UILabel = UILabel()
    //用户名
    fileprivate lazy var screenName  : UILabel = UILabel()
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//设置UI界面
extension ComposeTitleView{
    fileprivate func setupUI(){
        addSubview(titleLabel)
        addSubview(screenName)
        //设置frame
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenName.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        //设置控间的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenName.font = UIFont.systemFont(ofSize: 14)
        screenName.textColor = UIColor.lightGray
        //设置为字内容
        titleLabel.text = "发微博"
        screenName.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
