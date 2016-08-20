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
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showAnnotationOnMap()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain {
                if error != nil {
                    self.showAlert("Locations Not Found", withMessage: "download failed")
                }
                
                if success {
                    self.showAnnotationOnMap()
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
                } else {
                    showAlert("Invalid Link", withMessage: "")
                }
            }
        }
    }
    
    func didRefreshMap() {
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain() {
                if (error != nil) {
                    self.showAlert("Unsucessful Refresh", withMessage: "")
                }
                
                if success {
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations.removeAll()
                    self.showAnnotationOnMap()
                }
            }
        }
    }
    
    func showAnnotationOnMap() {
        for dictionary in StudentLocations.sharedInstance.sharedLocations {
            guard let lat = dictionary.latitude else {
                break
            }
            guard let long = dictionary.longitude else {
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
        mapView.addAnnotations(annotations)
    }
    
    
    func  showAlert(title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}
