//
//  VisitorView.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/13.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //MARK:- 提供快速通过xib创建方法
    class func visitorView() -> VisitorView{
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as!VisitorView
    }
    //MARK:- 空间属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipView: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    func setupVisitorInfo(iconName: String , title : String) {
        iconView.image = UIImage(named: iconName)
        tipView.text = title
        rotationView.isHidden = true
    }
    func addRotationAnimate(){
        //创建旋转动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        //设置动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        //将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
    
}

