//
//  ResultsOfCalculateRouteViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 1/09/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class ResultsOfCalculateRouteViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var descriptionLabel: DesignableLabel!
    @IBOutlet weak var resultView: DesignableView!
    @IBOutlet weak var recargosView: DesignableView!
    
    //MARK: View lifecycle & Initialization Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions 
    
    @IBAction func opacityButtonPressed() {
        descriptionLabel.animation = "fall"
        resultView.animation = "fall"
        recargosView.animation = "fall"
        descriptionLabel.animate()
        resultView.animate()
        recargosView.animate()
        
        delay(0.2) { () -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
