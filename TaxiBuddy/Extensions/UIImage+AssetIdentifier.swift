//
//  UIImage+AssetIdentifier.swift
//  TaxiBuddy
//
//  Created by Developer on 19/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//
//  This extension creates a convenience initializer of UIImage, that return a non-optional UIImage. 
//  The initializer doesn't take the image name as a String, but as an enumeration case, this way we 
//  can avoid typos, and all the images names are centralized in this extension.

import Foundation
import UIKit

extension UIImage {
    enum AssetIdentifier: String {
        case MiddleTabBarButton = "MiddleTabBarButton"
        case StartButton = "StartIcon"
        case StopButton = "StopIcon"
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}