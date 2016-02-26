//
//  MyAnnotation.swift
//  TaxiBuddy
//
//  Created by Developer on 27/08/15.
//  Copyright © 2015 iAm Studio. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var categoryId: Int
    var setOnMap: Bool
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, categoryId: Int, setOnMap: Bool) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.categoryId = categoryId
        self.setOnMap = setOnMap
    }
    
    convenience init(categoryId: Int) {
        self.init(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "", subtitle: "", categoryId: categoryId, setOnMap: false)
    }
}
