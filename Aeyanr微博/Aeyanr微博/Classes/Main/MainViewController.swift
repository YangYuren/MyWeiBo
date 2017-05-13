//
//  MainViewController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       addChildViewController(chileVC: HomeController(), title: "首页", imageName: "tabbar_home")
       addChildViewController(chileVC: MessageController(), title: "消息", imageName: "tabbar_message_center")
       addChildViewController(chileVC: DiscoverController(), title: "发现", imageName: "tabbar_discover")
       addChildViewController(chileVC: ProfileController(), title: "我", imageName: "tabbar_profile")
        
    }
    //Swift支持方法重载
    private func addChildViewController(chileVC: UIViewController , title: String , imageName : String) {
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
