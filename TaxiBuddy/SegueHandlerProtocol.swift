//
//  SegueHandlerProtocol.swift
//  TaxiBuddy
//
//  Created by Developer on 19/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//
//  This file declares a protocol SegueHanlderType and an extension of it. The extension allows us to 
//  check the identifier of a segue in the method -prepareForSegue, without having to write the literal
//  string name of the identifier. This helps to avoid typos

import Foundation
import UIKit

protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
                  segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid Segue identifier") }
        return segueIdentifier
    }
}