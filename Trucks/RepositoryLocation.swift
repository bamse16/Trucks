//
//  RepositoryLocation.swift
//  Trucks
//
//  Created by Marius Ursache on 9/12/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit
import Mapbox
import ObjectMapper

class RepositoryLocation {
    var locations: Array<Location>
    
    required init() {
        self.locations = Array<Location>()
    }
    
    func loadItems() {
        self.locations.removeAll()
        if let path = NSBundle.mainBundle().pathForResource("location", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let locationItems = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    if let jsLocations = Mapper<Location>().mapArray(locationItems) {
                        self.locations = jsLocations
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func asAnnotations() -> Array<MGLPointAnnotation> {
        let locations = self.locations.map { (location) -> MGLPointAnnotation in
            return LocationAnnotation(location)!.annotation() as MGLPointAnnotation
        }
        
        return locations
    }
    
    func geographicMidPoint() -> CLLocationCoordinate2D {
        var x: Double = 0
        var y: Double = 0
        var z: Double = 0
        var w: Double = 0

        if self.locations.count == 0 {
            return LocationXYZ(xD: x, yD: y, zD: z).asCoordinate()
        }
        
        for item in self.locations {
            let xyz = item.asLocationXYZ()
            
            x = x + xyz.x
            y = y + xyz.y
            z = z + xyz.z
            w = w + xyz.w
        }
        
        x = x / w
        y = y / w
        z = z / w
        
        let midPoint = LocationXYZ(xD: x, yD: y, zD: z).asCoordinate()
        return midPoint
    }
}
