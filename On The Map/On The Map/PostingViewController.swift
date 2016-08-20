//
//  PostingViewController.swift
//  On The Map
//
//  Created by lily on 8/16/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var annotations = [MKPointAnnotation]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userInteractionEnabled = false
        mapView.hidden = true
        linkTextField.hidden = true
        locationLabel.hidden = false
        [linkTextField, textField].forEach() {
            $0.delegate = self
        }
        activityIndicator.hidden = true
    }
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMap(sender: UIButton) {
        if let location = textField.text {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if error != nil {
                    self.showAlert("No Results Found", withMessage: "unable to find location")
                    return
                }
                
                // only make amends to the view if the forward geolocation was successful
                self.mapView.hidden = false
                self.locationLabel.hidden = true
                self.locationView.hidden = true
                self.findButton.hidden = true
                self.submitButton.hidden = false
                self.linkTextField.hidden = false
                
                if placemarks?.count > 0 {
                    var placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    guard let latitude = coordinate?.latitude else {
                        self.showAlert("No Results Found", withMessage: "unable to find location")
                        return
                    }
                    guard let longitude = coordinate?.longitude else {
                        self.showAlert("No Results Found", withMessage: "unable to find location" )
                        return
                    }
                    
                    // update the coordinates of the udacity for posting
                    UdacityUser.sharedInstance.latitude = latitude
                    UdacityUser.sharedInstance.longitude = longitude
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate  = coordinate!
                    self.annotations.append(annotation)
                    self.mapView.addAnnotations(self.annotations)
             
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark!))
                    placemark = MKPlacemark(placemark: placemark!)
                    
                    // center the map
                    let p = MKPlacemark(placemark: placemark!)
                    let span = MKCoordinateSpanMake(8, 8)
                    let region = MKCoordinateRegion(center: p.location!.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                        
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
            
                    
                }
            }
        }
    }
    
    @IBAction func postAStudentLocation(sender: UIButton) {
        if (linkTextField.text?.isEmpty ?? true) {
            showAlert("Missing Link", withMessage: "please enter a link to submit")
        } else {
            let jsonBody = "{\"uniqueKey\": \"\(UdacityUser.sharedInstance.key!)\", \"firstName\": \"\(UdacityUser.sharedInstance.firstName!)\", \"lastName\": \"\(UdacityUser.sharedInstance.lastName!)\",\"mapString\": \"\(textField.text!)\", \"mediaURL\": \"\(linkTextField.text!)\",\"latitude\": \(UdacityUser.sharedInstance.latitude!), \"longitude\": \(UdacityUser.sharedInstance.longitude!)}"
            
            ParseClient.sharedInstance().taskForPOSTMethod(ParseClient.Constants.Methods.StudentLocation, parameters: nil, jsonBody: jsonBody, methodType: ParseClient.Constants.ParameterKeys.MethodType) { (results, error) in
                performUIUpdatesOnMain() {
                    if error != nil {
                        self.showAlert("Failure to Post", withMessage: "Try Again...")
                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }

                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func  showAlert(title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }


}
