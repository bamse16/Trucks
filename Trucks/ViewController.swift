//
//  ViewController.swift
//  Trucks
//
//  Created by Marius Ursache on 22/05/2015.
//  Copyright (c) 2015 Marius Ursache. All rights reserved.
//

import UIKit
import MapboxGL

class ViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(40.73, -73.98), zoomLevel: 12, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Declare the annotation `point` and set its coordinates, title, and subtitle
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.734368, longitude: -73.986487)
        point.title = "Hello world!"
        point.subtitle = "Welcome to The Ellipse."
        
        self.mapView.addAnnotation(point)
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
            let image = UIImage(named: "marker")
            
            // Instantiate MGLAnnotationImage with our image and use it for this annotation
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "marker")
        }
        
        return annotationImage
    }
}
