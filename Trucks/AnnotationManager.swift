//
//  AnnotationManager.swift
//  Trucks
//
//  Created by Marius Ursache on 27/12/2015.
//  Copyright © 2015 Marius Ursache. All rights reserved.
//

import Mapbox

class AnnotationManager: NSObject {
    
    func annotationImage(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let deviceName = annotation.title {
            let deviceLocationView = DeviceLocationView()
            deviceLocationView.configure(deviceName!)
            
            let reuseIdentifier = deviceName!
            
            let image = deviceLocationView.mu_asImage()
            let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            return annotationImage
        }
        
        return nil
    }
}
