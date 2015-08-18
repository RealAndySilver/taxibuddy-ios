//
//  LoginViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 18/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var loginButton: DesignableButton!
    @IBOutlet weak var loginView: DesignableView!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    //Constants 
    private var loginButtonOriginalYPosition: CGFloat!

    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    //MARK: View Lifecycle & Initialization Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonOriginalYPosition = loginButtonBottomConstraint.constant
        
        //Register for Keyboard Notifications 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("Deinicializandoooo el login")
    }
    
    //MARK: Actions 
    
    @IBAction func opacityButtonPressed() {
        loginView.animation = "fadeOut"
        loginView.animate()
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
        let lowerPoint = CGPoint(x: loginButton.frame.origin.x, y: loginButton.frame.origin.y + loginButton.frame.size.height)
        let windowCoordinatesPoint = loginButton.superview!.convertPoint(lowerPoint, toView: nil)
        let invertedYPosition = view.bounds.size.height - windowCoordinatesPoint.y
        
        //If the invertedYPosition is less than the keyboard frame, it means the login view is hidden 
        //behind the keyboard, so we have to animate it up to be able to see it. 
        if invertedYPosition <= adjustmentHeight {
            let pointsDifference = adjustmentHeight - invertedYPosition
            loginButtonBottomConstraint.constant += pointsDifference + 20.0
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
        loginButtonBottomConstraint.constant = loginButtonOriginalYPosition
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
