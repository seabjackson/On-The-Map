//
//  PostingViewController.swift
//  On The Map
//
//  Created by lily on 8/16/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    var annotations = [MKPointAnnotation]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.hidden = true
        linkTextField.hidden = true
        locationLabel.hidden = false
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBAction func findOnMap(sender: UIButton) {
        mapView.hidden = false
        locationLabel.hidden = true
        locationView.hidden = true
        findButton.hidden = true
        submitButton.hidden = false
        linkTextField.hidden = false
        
        if let location = textField.text {
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if error != nil {
                    print(error)
                    return
                }
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                    if placemark?.areasOfInterest?.count > 0 {
                        let areaOfInterest = placemark!.areasOfInterest![0]
                        print(areaOfInterest)
                    } else {
                        print("No area of interest found")
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate  = coordinate!
                    self.annotations.append(annotation)
                    self.mapView.addAnnotations(self.annotations)
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
