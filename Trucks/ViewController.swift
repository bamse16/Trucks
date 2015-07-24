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
        
        let accessToken = "sk.eyJ1IjoiaHhxM3RzciIsImEiOiIyYzNlMGIyNTdiZjE5NDExMTU0YTZkNjQ1ZmZlMGFkMSJ9.80aHSYxCP2qtdRjPMeguuw"
        
        MGLAccountManager.setMapboxMetricsEnabledSettingShownInApp(true)
        MGLAccountManager.setAccessToken(accessToken)
        
        if(self.mapView != nil){
            self.mapView.accessToken = accessToken
        } else {
            self.mapView = MGLMapView(frame: self.view.bounds, accessToken:accessToken)
        }

        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(40.73, -73.98), zoomLevel: 12, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MGLMapViewDelegate

    func mapView(mapView: MGLMapView!, symbolNameForAnnotation annotation: MGLAnnotation!) -> String! {
        return "secondary_marker"
    }

}

