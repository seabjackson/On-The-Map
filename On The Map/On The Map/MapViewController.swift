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
        print("map view loaded")
        
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain {
                if let error = error {
                    print("An error occurred \(error)")
                }
                
                if success {
                    print("got the locations yeahh")
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
                }
            }
        }
    }
    
    func didRefreshMap() {
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain() {
                if (error != nil) {
                    print("error in getting results")
                }
                
                if success {
                    print("remove annotation")
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations.removeAll()
                    self.showAnnotationOnMap()
                }
            }
        }
    }
    
    func showAnnotationOnMap() {
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
        mapView.addAnnotations(annotations)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
