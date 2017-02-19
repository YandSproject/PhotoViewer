//
//  ScaleTransition.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/28.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class ScaleTransition: NSObject,UIViewControllerAnimatedTransitioning {

    let duration    : TimeInterval = 0.6
    let interval    : TimeInterval = 0.3
    let spring      : CGFloat = 0.8
    let velocity    : CGFloat = 0.1
    let hideAlpha   : CGFloat = 0.0
    let showAlpha   : CGFloat = 1.0
    
    var isBack : Bool = false
    var image    : UIImage?
    var fromRect : CGRect?
    var toRect   : CGRect?

    var toImageView     : UIImageView?
    var fromImageView   : UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        presentTransition(transitionContext: transitionContext, toView: toVC!.view, fromView: fromVC!.view)
    }
    
    func presentTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        var toCollectionView : UICollectionView?
        for (view) in toView.subviews {
            if let collectionView : UICollectionView = view as? UICollectionView {
                toCollectionView = collectionView
                break
            }
        }

        if isBack == false {
            toCollectionView?.alpha = hideAlpha
        }
        toView.alpha = hideAlpha

        containerView.frame = ScreenRect()
        toView.frame = ScreenRect()
        toView.layoutIfNeeded()
        toCollectionView?.layoutIfNeeded()
        
        let imageView : UIImageView = UIImageView(image: image ?? UIImage())
        imageView.clipsToBounds = true
        imageView.contentMode = self.isBack ? UIViewContentMode.scaleAspectFill : UIViewContentMode.scaleAspectFit
        imageView.frame = fromRect ?? CGRect.zero
        containerView.addSubview(imageView)
        
        toImageView?.alpha = hideAlpha
        fromImageView?.alpha = hideAlpha
        let delay : TimeInterval = isBack == true ? interval : 0.0
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: spring, initialSpringVelocity: velocity, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            imageView.frame = self.toRect ?? CGRect.zero
            toView.alpha = 1.0
            }) { [weak self] (Bool) in
                fromView.alpha = self?.hideAlpha ?? 0.0
                
                let alpha: CGFloat = self?.showAlpha ?? 1.0
                self?.toImageView?.alpha = alpha
                self?.fromImageView?.alpha = alpha
                toCollectionView?.alpha = alpha
                imageView.removeFromSuperview()

                transitionContext.completeTransition(true)
        }
    }
}
