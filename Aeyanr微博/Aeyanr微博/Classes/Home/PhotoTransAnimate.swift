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
    func animatedForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        //去除弹出的View
        let prented = transitionContext.view(forKey: .to)!
        //将presnet添加到ContainView
        transitionContext.containerView.addSubview(prented)
        //执行动画
        prented.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            prented.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    func animatedForDismissView(transitionContext: UIViewControllerContextTransitioning){
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
