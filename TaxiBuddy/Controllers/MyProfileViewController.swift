//
//  MyProfileViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 20/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func LogoutButtonPressed() {
        tabBarController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
