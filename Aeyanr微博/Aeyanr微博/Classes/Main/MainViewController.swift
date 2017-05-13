//
//  MainViewController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    //fileprivate lazy var composeBtn : UIButton  = UIButton.createButton(imageName: "tabbar_compose_icon_add", bgImageName:
    //    "tabbar_compose_button")
    fileprivate lazy var composeBtn : UIButton  = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposed()
    }
    //Swift支持方法重载
    private func addChildViewController(chileVcName: String , title: String , imageName : String) {
        //1.获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获得命名空间")
            return
        }
        //2.根据字符串获取对应的CLass
        guard let ChildVcVClass = NSClassFromString(nameSpace + "." + chileVcName) else {
            print("没有获得字符串对应的Class")
            return
        }
        //获取对应控制器的类型
        guard let childVcType = ChildVcVClass as?UIViewController.Type else {
            print("没有获取对应控制器的类型")
            return
        }
        //创建对应的控制器
        let chileVC = childVcType.init()
        //1.设置子控制器的属性
        chileVC.title = title
        chileVC.tabBarItem.image = UIImage(named: imageName)
        chileVC.tabBarItem.selectedImage = UIImage(named: imageName+"_highlighted")
        //2.包装导航控制器
        let chileNav = UINavigationController(rootViewController: chileVC)
        //3.添加控制器
        addChildViewController(chileNav)
    }
}
//MARK:- 设置UI界面
extension MainViewController {
   fileprivate func setupComposed(){
        tabBar.addSubview(composeBtn)
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height*0.5)
    }
}
