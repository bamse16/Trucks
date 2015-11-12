//
//  ViewController.swift
//  Trucks
//
//  Created by Marius Ursache on 22/05/2015.
//  Copyright (c) 2015 Marius Ursache. All rights reserved.
//

import UIKit
import Mapbox
import ObjectMapper

class ViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(38.076, -122.515), zoomLevel: 12, animated: false)
        
        let info = NSBundle.mainBundle().infoDictionary
        let pubnubChannel = info?["PubNubChannel"] as? String
        
        NSLog("using channel %@", pubnubChannel!)
        
        let locations = self.loadLocations().map { (location) -> MGLPointAnnotation in
            return LocationAnnotation(location)!.annotation() as MGLPointAnnotation
        }
        
        self.mapView.addAnnotations(locations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MGLMapViewDelegate

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Attempt to reuse a cached image
        var annotationImage = self.mapView.dequeueReusableAnnotationImageWithIdentifier("marker")
        
        if (annotationImage == nil) {
            // Load an image from your app bundle; requires 1x, 2x, and 3x assets
            let image = UIImage(named: "hydrant")
            
            // Instantiate MGLAnnotationImage with our image and use it for this annotation
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "marker")
        }
        
        return annotationImage
    }
    
    func loadLocations() -> Array<Location> {
        var locations = Array<Location>()
        if let path = NSBundle.mainBundle().pathForResource("location", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let locationItems = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    if let jsLocations = Mapper<Location>().mapArray(locationItems) {
                        locations = jsLocations
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return locations
    }
}
