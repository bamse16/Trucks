//
//  LocationAnnotation.swift
//  Trucks
//
//  Created by Marius Ursache on 13/11/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit
import Mapbox

class LocationAnnotation {
    let location: Location
    
    required init?(_ loc: Location) {
        self.location = loc
    }
    
    func annotation() -> MGLPointAnnotation {
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: self.location.latitude, longitude: self.location.longitude)
        point.title = self.location.username
        
        return point
    }
}
