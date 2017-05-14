//
//  AYPresentationController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/14.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class AYPresentationController: UIPresentationController {
    //MARK:- 懒加载属性
    fileprivate lazy var coverView : UIView = UIView()
    var popFrame : CGRect = CGRect.zero
    
    //MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //弹出控制器的frame
        presentedView?.frame = popFrame
        //添加蒙板
        setupCoverView()
    }
}
extension AYPresentationController {
    fileprivate func setupCoverView(){
        containerView?.insertSubview(coverView, at: 0)
        //这只蒙板属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        coverView.frame = containerView!.bounds
        //创建手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(AYPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}
//手势事件监听
extension AYPresentationController {
    @objc fileprivate func coverViewClick(){
        presentedViewController .dismiss(animated: true, completion: nil)
    }
}
