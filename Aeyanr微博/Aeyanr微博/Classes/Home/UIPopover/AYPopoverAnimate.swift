//
//  AYPopoverAnimate.swift
//  Aeyanr微博
//
//  Created by Yang on 2017/5/14.
//  Copyright © 2017年 Yang. All rights reserved.
//

import UIKit
//转场动画代理总代理
class AYPopoverAnimate: NSObject {
    //MARK:- 对外提供的属性
    var isPresented : Bool = false
    var presentedFrame : CGRect = CGRect.zero
    var callBack : ((_ presented : Bool)->())?
    //如果自定义一个构造函数，但没有默认的init()进行重写，那么自定义的构造函数就会覆盖默认的init()
    init(callBack : @escaping ((_ presented : Bool)->())) {
        self.callBack = callBack
    }
    
}
//转场动画代理
extension AYPopoverAnimate: UIViewControllerTransitioningDelegate{
    //目的：改变弹出的Controller的frame
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation =  AYPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.popFrame = presentedFrame
        return presentation
    }
    //目的：改变弹出的Controller的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = true
        callBack!(isPresented)
        return self
    }
    //目的：改变消失的Controller的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = false
        callBack!(isPresented)
        return self
    }
}
extension AYPopoverAnimate : UIViewControllerAnimatedTransitioning{
    //动画执行时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    //获取弹出的View 与 消失的View
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        isPresented ? animatePresentView(transitionContext: transitionContext) : animateDismissView(transitionContext: transitionContext)
    }
    //自定义弹出动画
    fileprivate func animatePresentView(transitionContext: UIViewControllerContextTransitioning){
        //获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //将弹出的View添加到containerView
        transitionContext.containerView.addSubview(presentedView)
        //执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        //设置锚点
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            //告诉上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    //消失自定义动画
    fileprivate func animateDismissView(transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        //执行动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //转场动画 IOS对临界值处理不好  y设为0动画效果不好
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            //移除
            dismissView?.removeFromSuperview()
            //告诉上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}

