//
//  ConsultarPlacaViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 24/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ConsultarPlacaViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var placaTextfield: DesignableTextField!

    /////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////
    //MARK: View lifecycle & Initialization Stuff
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions 
    
    @IBAction func shareButtonPressed() {
        let shareAlert = UIAlertController(title: "", message: "¿De que manera deseas compartir la placa?", preferredStyle: .ActionSheet)
        shareAlert.addAction(UIAlertAction(title: "Facebook", style: .Default, handler: { (_) -> Void in
            //Present the Facebook modal
            self.presentSocialSharingModalWithServiceType(SLServiceTypeFacebook)
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: { (_) -> Void in
            //Preent the Twiiter modal
            self.presentSocialSharingModalWithServiceType(SLServiceTypeTwitter)
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Email", style: .Default, handler: { (_) -> Void in
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setSubject("Placas Taxi")
            mailController.setMessageBody("Me acabo de subir al taxi de placas \(self.placaTextfield.text)", isHTML: false)
            self.presentViewController(mailController, animated: true, completion: nil)
        }))
        
        shareAlert.addAction(UIAlertAction(title: "SMS", style: .Default, handler: { (_) -> Void in
            if !MFMessageComposeViewController.canSendText() { return }
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate = self
            messageController.body = "Me acabo de subir al tai de placas \(self.placaTextfield.text)"
            self.presentViewController(messageController, animated: true, completion: nil)
        }))
        
        shareAlert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(shareAlert, animated: true, completion: nil)
    }
    
    //MARK: Custom stuff
    
    func presentSocialSharingModalWithServiceType(serviceType: String) {
        if serviceType != SLServiceTypeFacebook && serviceType != SLServiceTypeTwitter { return }
        let socialSharingController = SLComposeViewController(forServiceType: serviceType)
        socialSharingController.setInitialText("Me acabo de subir al taxi de placas \(self.placaTextfield.text)")
        presentViewController(socialSharingController, animated: true, completion: nil)
    }
}

//MARK: MFMailComposeViewControllerDelegate

extension ConsultarPlacaViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: MFMessageComposeDelegate

extension ConsultarPlacaViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: UITextfieldDelegate

extension ConsultarPlacaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
