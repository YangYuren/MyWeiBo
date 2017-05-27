//
//  ProgressVeiw.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/26.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class ProgressVeiw: UIView {
    //定义进度属性
    var progress : CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    //重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        //获取参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startangle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startangle
        //创建巴塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startangle, endAngle: endAngle, clockwise: true)
        //绘制一条到中心点得线
        path.addLine(to: center)
        path.close()
        //设置绘制颜色
        UIColor(white: 1, alpha: 0.4).setFill()
        //开始绘制
        path.fill()

   }
}
