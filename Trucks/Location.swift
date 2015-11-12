//
//  Location.swift
//  Trucks
//
//  Created by Marius Ursache on 13/11/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import UIKit
import ObjectMapper

class Location: NSObject, Mappable {
    var active: Bool!
    var modifiedDate: NSDate!
    var latitude: Double!
    var longitude: Double!
    var username: String!
    var uuid: String?

    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        active          <- map["active"]
        modifiedDate    <- (map["modified_unix_date"], DateTransform())
        latitude        <- map["location.latitude"]
        longitude       <- map["location.longitude"]
        uuid            <- map["uuid"]
        username        <- map["username"]
    }
    
    override var description: String {
        let activeStr = self.active == true ? "active" : "inactive"
        return String(format: "Location %@, u:%@ lat/lon:%f,%f modified:%@",
            activeStr, self.username, self.latitude, self.longitude, self.modifiedDate)
    }
}
