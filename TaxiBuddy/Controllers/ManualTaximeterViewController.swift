//
//  ManualTaximeterViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 21/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class ManualTaximeterViewController: UIViewController {
    
    //Enums
    enum ViewToPan: Int {
        case TaximeterUnitsView = 1
        case RecargosView
    }
    
    //Outlets
    @IBOutlet weak var taximeterUnitLabel: UILabel!
    @IBOutlet weak var recargosView: DesignableView!
    @IBOutlet weak var taximeterUnitsView: DesignableView!
    
    //Private variables
    private var taximeterRange = (minUnits: 25, maxUnits: 300)
    private var firstTimeViewAppears = true
    private var recargosViewCenter: CGPoint!
    private var taximeterUnitsCenter: CGPoint!
    
    //UIKitDynamics
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var recargosViewSnapBehavior: UISnapBehavior!
    private var taximeterUnitsViewSnapBehavior: UISnapBehavior!
    private var collisionBehavior: UICollisionBehavior!
    private var springAttachmentBehavior: UIAttachmentBehavior!
    private var panningRecargosView = false
    private var panningTaximeterUnitsView = false
    
    ///////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////
    //MARK: View Lifecycle & Initialization Stuff

    override func viewDidLoad() {
        super.viewDidLoad()
        taximeterUnitLabel.text = "\(taximeterRange.minUnits)"
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        recargosViewCenter = recargosView.center
        taximeterUnitsCenter = taximeterUnitsView.center
        print(recargosViewCenter)
        
        if firstTimeViewAppears {
            collisionBehavior = UICollisionBehavior(items: [recargosView, taximeterUnitsView])
            animator.addBehavior(collisionBehavior)
            firstTimeViewAppears = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions 
    
    @IBAction func minusButtonPressed() {
        let taximeterUnits = Int(taximeterUnitLabel.text!)!
        if taximeterUnits > taximeterRange.minUnits {
            taximeterUnitLabel.text = "\(taximeterUnits - 1)"
        }
    }
    
    @IBAction func plusButtonPressed() {
        let taximeterUnits = Int(taximeterUnitLabel.text!)!
        if taximeterUnits < taximeterRange.maxUnits {
            taximeterUnitLabel.text = "\(taximeterUnits + 1)"
        }
    }

    @IBAction func panningInViewDetected(sender: UIPanGestureRecognizer) {
        let pannedView = sender.view!
        let generalLocation = sender.locationInView(view)
        let boxLocation = sender.locationInView(pannedView)
        
        let attachedView: UIView
        if pannedView.tag == ViewToPan.RecargosView.rawValue {
            attachedView = taximeterUnitsView
        } else {
            attachedView = recargosView
        }
        
        if sender.state == .Began {
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(pannedView.bounds), boxLocation.y - CGRectGetMidY(pannedView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: pannedView, offsetFromCenter: centerOffset, attachedToAnchor: generalLocation)
            springAttachmentBehavior = UIAttachmentBehavior(item: pannedView, attachedToItem: attachedView)
            springAttachmentBehavior.damping = 10.0
            springAttachmentBehavior.frequency = 0.0
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
            animator.addBehavior(springAttachmentBehavior)
            
        } else if sender.state == .Changed {
            attachmentBehavior.anchorPoint = generalLocation
            
        } else if sender.state == .Ended {
            animator.removeBehavior(attachmentBehavior)
            recargosViewSnapBehavior = UISnapBehavior(item: recargosView, snapToPoint: recargosViewCenter)
            taximeterUnitsViewSnapBehavior = UISnapBehavior(item: taximeterUnitsView, snapToPoint: taximeterUnitsCenter)
            animator.addBehavior(recargosViewSnapBehavior)
            animator.addBehavior(taximeterUnitsViewSnapBehavior)
        }
    }
}
