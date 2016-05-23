//
//  MapViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: OTMNavigationViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(locationDataUpdated), name: Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
        
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            openUrlFrom((view.annotation?.subtitle!))
        }
    }
    
    func locationDataUpdated() {

        var annotations = [MKPointAnnotation]()
        
        if let locations = locations {
            for location in locations {
            
                let lat = CLLocationDegrees(Double(location.latitude))
                let long = CLLocationDegrees(Double(location.longtitude))
                
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = location.firstName
                let last = location.lastName
                let mediaURL = location.mediaURL
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
    
                annotations.append(annotation)
            }
            
            performUIUpdatesOnMain({ 
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            })
            
        }
    }
        
}

