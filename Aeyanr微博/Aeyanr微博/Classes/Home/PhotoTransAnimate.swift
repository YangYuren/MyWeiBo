//
//  PhotoTransAnimate.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/27.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit

class PhotoTransAnimate: NSObject {
    var isPresented : Bool = false
    var presentedDelegate : AnimatePresentedDelegate?
    var indexpath : IndexPath?
}
//面向协议开发
protocol AnimatePresentedDelegate : NSObjectProtocol{
    func startRect(indexpath : IndexPath) -> CGRect//开始所在尺寸
    func endRect(indexpath : IndexPath) -> CGRect//结束为止
    func imageView(indexPath : IndexPath) -> UIImageView//零时image
}


extension PhotoTransAnimate : UIViewControllerTransitioningDelegate {
    //自动以弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
extension PhotoTransAnimate : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animatedForPresentedView(transitionContext: transitionContext) : animatedForDismissView(transitionContext: transitionContext)
    }
    func animatedForPresentedView(transitionContext: UIViewControllerContextTransitioning){//弹出动画
        guard let presentedDelegate = presentedDelegate , let indexpath = indexpath else {
            return
        }
        //去除弹出的View
        let prented = transitionContext.view(forKey: .to)!
        //将presnet添加到ContainView
        transitionContext.containerView.addSubview(prented)
        
        let startRect = presentedDelegate.startRect(indexpath: indexpath)
        let imageVeiw = presentedDelegate.imageView(indexPath: indexpath)
        transitionContext.containerView.addSubview(imageVeiw)
        imageVeiw.frame = startRect
        
        //执行动画
        prented.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageVeiw.frame = presentedDelegate.endRect(indexpath: indexpath)//设置最后的frame
        }) { (_) in
            imageVeiw.removeFromSuperview()
            prented.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    func animatedForDismissView(transitionContext: UIViewControllerContextTransitioning){//关闭动画
        let dismisView = transitionContext.view(forKey: .from)
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismisView?.alpha = 0.0
        }) { (_) in
            dismisView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
