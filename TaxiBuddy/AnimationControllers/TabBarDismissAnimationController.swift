
//
//  TabBarDismissAnimationController.swift
//  TaxiBuddy
//
//  Created by Developer on 20/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class TabBarDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        let containerView = transitionContext.containerView()!
        toViewController.view.frame = finalFrame
        //toViewController.view.alpha = 0.5
        
        containerView.addSubview(toViewController.view)
        containerView.sendSubviewToBack(toViewController.view)
        
        //Determine the intermediate and final frame for the "from" view 
        let shrunkenFrame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width/4.0, fromViewController.view.frame.size.height/4.0)
        let fromFinalFrame = CGRectOffset(shrunkenFrame, 0.0, UIScreen.mainScreen().bounds.size.height)
        let duration = transitionDuration(transitionContext)
        
        //Create a snapshot of the "from" view
        let intermediateView = fromViewController.view.snapshotViewAfterScreenUpdates(false)
        intermediateView.frame = fromViewController.view.frame
        containerView.addSubview(intermediateView)
        intermediateView.layer.zPosition = 1000
        intermediateView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        intermediateView.layer.position.y = UIScreen.mainScreen().bounds.size.height
        //Remove the real "from" view 
        fromViewController.view.removeFromSuperview()
        
        //Define the 3d transform to apply to the "from" viewcontroller
        var rotationAndPerspectiveTransform = intermediateView.layer.transform
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI_2), 1, 0, 0)
        
        //Animate with keyframes 
        UIView.animateKeyframesWithDuration(duration,
            delay: 0.0,
            options: UIViewKeyframeAnimationOptions.CalculationModeCubic,
            animations: { () -> Void in
                //First keyframe 
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: { () -> Void in
                    //intermediateView.frame = shrunkenFrame
                    intermediateView.layer.transform = rotationAndPerspectiveTransform
                    //toViewController.view.alpha = 0.5
                })
                
                //Second keyframe 
                /*UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    //intermediateView.frame = fromFinalFrame
                    //toViewController.view.alpha = 1.0
                })*/
            }) { (succeded) -> Void in
                intermediateView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}
