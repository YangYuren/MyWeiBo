//
//  AYWelcomeController.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/18.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
import SDWebImage
class AYWelcomeController: UIViewController {
    //MARK:- 拖线属性
    @IBOutlet weak var iconViewBottom: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileURL = UserAccountViewModel.shareInstance.account?.avatar_large
        // ?? 如果前面问号类型有值，那么将前面类型进行解包并赋值
        //否则 那么直接使用??后面的值
        let url = URL(string: profileURL ?? "")
        //设置头像
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default"))
        //改变约束值
        iconViewBottom.constant = UIScreen.main.bounds.size.height - 200
        //执行动画
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: { 
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconView.layer.cornerRadius = 45
        iconView.layer.masksToBounds = true
    }
}
