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
    var locationsURL: URL?
    var cookie: String?
    var updateItemsTimer: Timer?
    
    let timerUpdateInterval: TimeInterval = 5

    var delegate: RepositoryLocationDelegate?
    
    required init() {
        self.locations = Array<Location>()
    }
    
    func configure(url: URL?, cookie: String?) {
        self.locationsURL = url
        self.cookie = cookie
    }
    
    func loadItems() {
        self.locations.removeAll()
        
        guard let path = Bundle.main.path(forResource: "location", ofType: "json") else { return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe)
            if let locationItems = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]] {
                if let jsLocations = Mapper<Location>().mapArray(JSONArray: locationItems) {
                    self.locations = jsLocations
                }
            }
        } catch {
            print(error.localizedDescription)
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
    
    func getItems<T: Mappable>(url: URL, cookie: String?, completion: @escaping (Array<T>)->Void) {
        var parsedList = Array<T>()
        
        var extraHeaders = Dictionary<String, String>()
        extraHeaders["Content-Type"] = "application/json";
        extraHeaders["Accept"] = "application/json";
        
        if let cookie = cookie {
            extraHeaders["Cookie"] = cookie;
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = extraHeaders
        
        let request = URLRequest(url: url)
        let urlSession = URLSession(configuration: sessionConfig)
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err)
            } else {
                do {
                    if let locationItems = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        if let jsLocations = Mapper<T>().mapArray(JSONArray: locationItems) {
                            parsedList = jsLocations
                        }
                    }
                
                } catch {
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(parsedList)
            }
        }
        dataTask.resume()
    }

    func getLocations(completion: @escaping (Array<Location>)->Void) {
        self.locations = Array<Location>()
        if let locationsURL = self.locationsURL {
            self.getItems(url: locationsURL, cookie:self.cookie, completion: completion)
        } else {
            completion(self.locations)
        }
    }
    
    func startLocationsSync() {
        if self.updateItemsTimer == nil {
            self.updateItemsTimer = Timer(timeInterval: self.timerUpdateInterval, target: self, selector: #selector(RepositoryLocation.locationSyncTick), userInfo: nil, repeats: true)
            RunLoop.main.add(self.updateItemsTimer!, forMode: .commonModes)
        }
    }
    
    @objc func locationSyncTick() {
        if let locationsURL = self.locationsURL {
            self.getItems(url: locationsURL, cookie: self.cookie, completion: { (locations: Array<Location>) -> Void in
                self.locationsDidLoad(items: locations)
            })
        } else {
            self.locationsDidLoad(items: Array<Location>())
        }
    }
    
    func locationsDidLoad(items:Array<Location>) {
        DispatchQueue.main.async {
            self.delegate?.locationsDidLoad(items: items)
        }
    }
}
