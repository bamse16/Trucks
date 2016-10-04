//
//  Location.swift
//  Trucks
//
//  Created by Marius Ursache on 13/11/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit
import MapKit
import Mapbox
import ObjectMapper

struct LocationXYZ {
    var x: Double
    var y: Double
    var z: Double
    var w: Double = 1
    
    var latitude: Double
    var longitude: Double
    
    init(lat: Double, lng: Double) {
        latitude = lat
        longitude = lng
        
        let latitudeRadian : Double = latitude * M_PI/180.0
        let longitudeRadian : Double = longitude * M_PI/180.0

        x = cos(latitudeRadian) * cos(longitudeRadian)
        y = cos(latitudeRadian) * sin(longitudeRadian)
        z = sin(latitudeRadian)
    }
    
    init(xD: Double, yD: Double, zD: Double) {
        x = xD
        y = yD
        z = zD
        
        let longitudeRadian = atan2(y, x)
        let hyp = sqrt((x * x) + (y * y))
        let latitudeRadian = atan2(z, hyp)
        
        latitude = latitudeRadian * 180.0/M_PI
        longitude = longitudeRadian * 180.0/M_PI
    }
    
    func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}

enum LocationType: String {
    case iPad = "ipad"
    case Truck = "truck"
}

class Location: NSObject, Mappable, MGLAnnotation {
    var active: Bool!
    var modifiedDate: Date!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var username: String = ""
    var uuid: String?
    var type: LocationType = LocationType.iPad
    
    // MARK: - MGLAnnotation
    
    var title: String? {
        get {
            return self.username
        }
    }
        
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
    }

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        active          <- map["active"]
        modifiedDate    <- (map["modified_unix_date"], DateTransform())
        latitude        <- map["location.latitude"]
        longitude       <- map["location.longitude"]
        uuid            <- map["uuid"]
        username        <- map["username"]
        type            <- map["device_type"]
    }
    
    override var description: String {
        let activeStr = self.active == true ? "active" : "inactive"
        return String(format: "Location %@, u:%@ lat/lon:%f,%f modified:%@",
            activeStr, self.username, self.latitude, self.longitude, self.modifiedDate.description)
    }
    
    func asLocationXYZ() -> LocationXYZ {
        return LocationXYZ(lat: self.latitude, lng: self.longitude)
    }
    
    func stringType() -> String {
        var strType: String
        switch self.type {
        case LocationType.Truck:
            strType = "Truck"
            
        default:
            strType = "iPad"
        }
        
        return strType
    }
}
