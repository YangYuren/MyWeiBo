//
//  BaseViewController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    //MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    //MARK:- 定义变量
    var isLogin : Bool = true
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgationItems()
    }
}
//MARK:- 设置访客视图
extension BaseViewController{
    fileprivate func setupVisitorView() {
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
}
//MARK:- 设置导航栏左右Item
extension BaseViewController {
    fileprivate func setupNavgationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册 ", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick));
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick));
        
    }
}
//MARK:- 事件监听
extension BaseViewController {
    @objc fileprivate func registerBtnClick(){
        print("register")
    }
    @objc fileprivate func loginBtnClick(){
        print("login")
    }
}
