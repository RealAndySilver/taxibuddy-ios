//
//  InitialViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 14/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInWithLabel: UILabel!
    
    //Private vars
    private var firstTimeViewAppears = true
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    //MARK: View Lifecycle & Initialization stuff

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeViewAppears {
            animateUI()
            firstTimeViewAppears = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        createAccountButton.alpha = 0.0
        signInButton.alpha = 0.0
        signInWithLabel.alpha = 0.0
    }
    
    //MARK: Animations
    
    private func animateUI() {
        UIView.animateWithDuration(0.3,
            delay: 0.3,
            options: .CurveLinear,
            animations: { () -> Void in
                self.createAccountButton.alpha = 1.0
                self.signInButton.alpha = 1.0
                self.signInWithLabel.alpha = 1.0
            }) { (succeded) -> Void in
                
        }
    }
    
    //MARK: Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToCreateAccountSegue" {
            let createAccountVC = segue.destinationViewController as! CreateAccountViewController
            createAccountVC.delegate = self
            
            //The user is moving to the CreateAccountVC, so hide the "Iniciar Sesion" button
            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: .CurveLinear,
                animations: { () -> Void in
                    self.signInButton.alpha = 0.0
                    self.signInWithLabel.alpha = 0.0
                }, completion: { (succeded) -> Void in }
            )
        }
    }
}

//MARK: CreateAccountViewControllerDelegate

extension InitialViewController: CreateAccountViewControllerDelegate {
    func createAccountVCIsBeingRemovedFromParent() {
        //Unhide the "inciar Sesión" button
        if signInButton.alpha == 0.0 {
            UIView.animateWithDuration(0.3,
                delay: 0.2,
                options: .CurveLinear,
                animations: { () -> Void in
                    self.signInButton.alpha = 1.0
                    self.signInWithLabel.alpha = 1.0
                }, completion: { (succeded) -> Void in }
            )
        }
    }
}
