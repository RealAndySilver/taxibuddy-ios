//
//  CreateAccountViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 18/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

protocol CreateAccountViewControllerDelegate: class {
    func createAccountVCIsBeingRemovedFromParent()
}

class CreateAccountViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var createAccountView: DesignableView!
    @IBOutlet weak var createAccountButton: DesignableButton!
    @IBOutlet weak var privacyPolicyLabel: DesignableLabel!
    @IBOutlet weak var createAccountButtonBottomConstraint: NSLayoutConstraint!
    
    //Public Variables
    weak var delegate: CreateAccountViewControllerDelegate?
    
    //Private variables 
    private var createAccountButtonOriginalYPosition: CGFloat!

    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    //MARK: View lifecycle & Initialization Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButtonOriginalYPosition = createAccountButtonBottomConstraint.constant
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("Deinicializando el create account")
    }
    
    //MARK: Actions 
    
    @IBAction func opacityButtonPressed() {
        //We use the delegate to inform the InitialViewController that this controller is dissapearing,
        //so we know when to unhide the "Iniciar Sesion" button from the InitialViewController. We could unhide
        //the button in -viewWillAppear (in InitialViewController), but because we presented this controller using 
        //the "Over current context" transition, -viewWillAppear is not called in InitialViewController when we 
        //dismiss this controller
        delegate?.createAccountVCIsBeingRemovedFromParent()
        
        createAccountView.animation = "fadeOut"
        createAccountView.animate()
        privacyPolicyLabel.animation = "fadeOut"
        privacyPolicyLabel.animate()
        delay(0.2) { () -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: Notification Handlers 
    
    func keyboardWillAppear(notification: NSNotification) {
        //We will use this func to animate the login view up the screen
        //Get the height of the keyboard
        let notificationInfo = notification.userInfo!
        let keyboardFrame = (notificationInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let adjustmentHeight = keyboardFrame.height
        
        //Get the lower left corner of the LoginButton
        let lowerPoint = CGPoint(x: createAccountButton.frame.origin.x, y: createAccountButton.frame.origin.y + createAccountButton.frame.size.height)
        let windowCoordinatesPoint = createAccountButton.superview!.convertPoint(lowerPoint, toView: nil)
        let invertedYPosition = view.bounds.size.height - windowCoordinatesPoint.y
        
        //If the invertedYPosition is less than the keyboard frame, it means the login view is hidden
        //behind the keyboard, so we have to animate it up to be able to see it.
        if invertedYPosition <= adjustmentHeight {
            let pointsDifference = adjustmentHeight - invertedYPosition
            createAccountButtonBottomConstraint.constant += pointsDifference + 20.0
            view.setNeedsUpdateConstraints()
            UIView.animateWithDuration(0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.0,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }, completion: { (succeded) -> Void in
                    
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //Reposition the login view to its original position
        createAccountButtonBottomConstraint.constant = createAccountButtonOriginalYPosition
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (succeded) -> Void in
                
        }
    }
}

//MARK: UITextfieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
