//
//  TabBarChangeAnimationController.swift
//  TaxiBuddy
//
//  Created by Developer on 20/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class TabBarChangeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()!
        toViewController.view.frame = finalFrame
        //toViewController.view.alpha = 1.0
        //containerView.addSubview(toViewController.view)
        let duration = transitionDuration(transitionContext)
        
        let toViewControllerSnapshot = toViewController.view.snapshotViewAfterScreenUpdates(true)
        toViewControllerSnapshot.frame = CGRectOffset(fromViewController.view.frame, 40.0, 0.0)
        toViewControllerSnapshot.alpha = 0.5
        containerView.addSubview(toViewControllerSnapshot)
        
        UIView.animateKeyframesWithDuration(duration,
            delay: 0.0,
            options: UIViewKeyframeAnimationOptions.CalculationModeLinear,
            animations: { () -> Void in
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0,
                    animations: { () -> Void in
                        toViewControllerSnapshot.alpha = 1.0
                        toViewControllerSnapshot.frame = finalFrame
                })
            }) { (succeded) -> Void in
                print("Termine la animaciooooonnn")
                containerView.addSubview(toViewController.view)
                fromViewController.view.removeFromSuperview()
                toViewControllerSnapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}
