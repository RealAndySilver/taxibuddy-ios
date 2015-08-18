//
//  MainTabBarViewController.swift
//  TaxiBuddy
//
//  Created by Developer on 18/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    var centerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 55.0))
        centerButton.setBackgroundImage(UIImage(named: "MiddleTabBarButton"), forState: .Normal)
        let heightDifference = centerButton.frame.size.height - tabBar.frame.size.height
        
        if heightDifference < 0 {
            centerButton.center = tabBar.center
            print("Height diference")
        } else {
            print("Not height diference")
            var center = tabBar.center
            center.y = center.y - heightDifference/2.0
            centerButton.center = center
        }
        view.addSubview(centerButton)
        
        //Go to the center tab view controller
        selectedIndex = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
