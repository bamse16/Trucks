//
//  AnnotationManager.swift
//  Trucks
//
//  Created by Marius Ursache on 27/12/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import Mapbox

class AnnotationManager: NSObject {
    
    func annotationImage(mapView: MGLMapView, imageForLocation location: Location) -> MGLAnnotationImage? {
        let deviceLocationView = DeviceLocationView()
        deviceLocationView.configure(location: location)
        
        if let image = deviceLocationView.mu_asImage(), let reuseIdentifier = location.title {
            let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            return annotationImage
        }
        
        return nil
    }
}
