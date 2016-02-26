//
//  UIColor+AppColors.swift
//  TaxiBuddy
//
//  Created by Developer on 18/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func getAppPrimaryColor() -> UIColor {
        return UIColor(red: 253.0/255.0, green: 144.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    }
    
    class func getAppSecondaryColor() -> UIColor {
        return UIColor(red: 253.0/255.0, green: 196.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    }
    
    class func getAppThirdColor() -> UIColor {
        return UIColor(red: 85.0/255.0, green: 195.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
}