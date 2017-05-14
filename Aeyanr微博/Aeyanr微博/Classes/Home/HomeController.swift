//
//  HomeController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class HomeController: BaseViewController {
    //MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButtom = TitleButtom()
    fileprivate lazy var popoverAnimate : AYPopoverAnimate  = AYPopoverAnimate { [weak self](presented) in
        self?.titleBtn.isSelected = presented
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录时候的内容
        visitorView.addRotationAnimate()
        if !isLogin {
            return
        }
        //设置导航栏的内容
        setupNavigationBar()
    }
    
}
//MARK:- 设置UI界面
extension HomeController {
    fileprivate func setupNavigationBar(){
        //左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //右侧Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //titleButton
        
        titleBtn.setTitle("杨玉仁", for: .normal)
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(HomeController.titleBtnClick(titleBtn:)), for: .touchUpInside)
    }
}
//MARK:- 时间监听函数
extension HomeController {
    @objc fileprivate func titleBtnClick(titleBtn : TitleButtom){
        titleBtn.isSelected = !titleBtn.isSelected
        //设置弹出控制器
        let vc = PopoverViewController()
        //设置model的样式
        vc.modalPresentationStyle = .custom
        //设置转场动画代理
        popoverAnimate.presentedFrame = CGRect(x: 90, y: 55, width: 180, height: 240)
        vc.transitioningDelegate = popoverAnimate
        //弹出控制器
        present(vc, animated: true, completion: nil)
    }
}








