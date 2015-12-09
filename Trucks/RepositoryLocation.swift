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
    
    required init(){
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
}
