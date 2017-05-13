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
    var isLogin : Bool = false
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension BaseViewController{
    fileprivate func setupVisitorView() {
        view = visitorView
    }
}
