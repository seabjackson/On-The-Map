//
//  MapViewController.swift
//  On The Map
//
//  Created by lily on 7/29/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        print("map view loaded")
        var annotations = [MKPointAnnotation]()
        
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    print("An error occurred \(error)")
                }
                
                if success {
                    print("got the locations yeahh")
                    for dictionary in sharedLocations {
                        guard let lat = dictionary.latitude else {
                            print("no lat")
                            break
                        }
                        guard let long = dictionary.longitude else {
                            print("no long")
                            break
                        }
                        let latitude = CLLocationDegrees(lat)
                        let longitude = CLLocationDegrees(long)
                        
                        // create the CLLocationCoordinates2D with lat and long
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        let first = dictionary.firstName!
                        let last = dictionary.lastName!
                        let mediaURL = dictionary.mediaURL!
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        annotations.append(annotation)
                        
                    }
                    self.mapView.addAnnotations(annotations)
                }
            }
        }
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                // safely open the url
                if let urlString = NSURL(string: toOpen) {
                    app.openURL(urlString)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
