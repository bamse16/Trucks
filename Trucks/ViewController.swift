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

class ViewController: UIViewController, MGLMapViewDelegate, RepositoryLocationDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    var repository: RepositoryLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(38.076, -122.515), zoomLevel: 12, animated: false)
        
        let info = NSBundle.mainBundle().infoDictionary
        let locationString = info?["APILocationEndpoint"] as? String
        let locationUseHTTPS = info?["APILocationUseHTTPS"] as? String
        let locationCookie = info?["APILocationCookie"] as? String
        
        self.repository = RepositoryLocation()
        repository.delegate = self
        
        if let locationString = locationString, useHTTPS = locationUseHTTPS {
            let httpsPrefix = (useHTTPS == "true") ? "https://" : "http://"
            let locationS = String(format:"%@%@", httpsPrefix, locationString)
            
            let locationURL = NSURL(string: locationS)
            repository.configure(locationURL, cookie: locationCookie)
        }

        // Adding the annotations after 1.3 seconds,
        // Otherwise, they won't show up
        // Workaround for 
        // https://github.com/mapbox/mapbox-gl-native/issues/1675
        // https://github.com/mapbox/mapbox-gl-native/issues/2956
        delay(1.3) {
            self.repository.locationSyncTick()
            self.repository.startLocationsSync()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MGLMapViewDelegate

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotationManager = AnnotationManager()
        
        if let location = annotation as? Location {
            let image = annotationManager.annotationImage(mapView, imageForLocation: location)
            return image
        }
        
        return nil
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: RepositoryLocationDelegate
    
    func locationsDidLoad(items:Array<Location>) {
        var shouldShowAnnotations = false
        if let currentAnnotations = self.mapView.annotations {
            self.mapView.removeAnnotations(currentAnnotations)
        } else {
            shouldShowAnnotations = true
        }
        
        self.repository.locations = items
        self.mapView.addAnnotations(self.repository.locations)
        
        if shouldShowAnnotations {
            self.mapView.showAnnotations(self.repository.locations, animated: true)
        }
    }
}
