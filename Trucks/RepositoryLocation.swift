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

protocol RepositoryLocationDelegate {
    func locationsDidLoad(items:Array<Location>)
}

class RepositoryLocation {
    var locations: Array<Location>
    var locationsURL: NSURL?
    var cookie: String?
    var updateItemsTimer: NSTimer?
    
    let timerUpdateInterval: NSTimeInterval = 5

    var delegate: RepositoryLocationDelegate?
    
    required init() {
        self.locations = Array<Location>()
    }
    
    func configure(url: NSURL?, cookie: String?) {
        self.locationsURL = url
        self.cookie = cookie
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
    
    func getItems<T: Mappable>(url: NSURL, cookie: String?, completion:(Array<T>)->Void) {
        var parsedList = Array<T>()
        
        var extraHeaders = Dictionary<String, String>()
        extraHeaders["Content-Type"] = "application/json";
        extraHeaders["Accept"] = "application/json";
        
        if let cookie = cookie {
            extraHeaders["Cookie"] = cookie;
        }

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = extraHeaders

        let request = NSURLRequest(URL: url)
        let urlSession = NSURLSession(configuration: sessionConfig)
        let dataTask = urlSession.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            if (error == nil) {
                do {
                    if let locationItems = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray {
                        if let jsLocations = Mapper<T>().mapArray(locationItems) {
                            parsedList = jsLocations
                        }
                    }

                    // success ...
                } catch {
                    // failure
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                }
            } else {
                print(error)
            }
            
            // call the completion function (on the main thread)
            dispatch_async(dispatch_get_main_queue()) {
                completion(parsedList)
            }
        }
        dataTask.resume()
    }

    func getLocations(completion:(Array<Location>)->Void) {
        self.locations = Array<Location>()
        if let locationsURL = self.locationsURL {
            self.getItems(locationsURL, cookie:self.cookie, completion: completion)
        } else {
            completion(self.locations)
        }
    }
    
    func startLocationsSync() {
        if self.updateItemsTimer == nil {
            self.updateItemsTimer = NSTimer(timeInterval: self.timerUpdateInterval, target: self, selector: Selector("locationSyncTick"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(self.updateItemsTimer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    @objc func locationSyncTick() {
        if let locationsURL = self.locationsURL {
            self.getItems(locationsURL, cookie: self.cookie, completion: { (locations: Array<Location>) -> Void in
                self.locationsDidLoad(locations)
            })
        } else {
            self.locationsDidLoad(Array<Location>())
        }
    }
    
    func locationsDidLoad(items:Array<Location>) {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.locationsDidLoad(items)
        }
    }
}
