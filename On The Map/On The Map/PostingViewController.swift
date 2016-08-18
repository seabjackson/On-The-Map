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
    
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
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
                    guard let latitude = coordinate!.latitude as? Double else {
                        print("couldn't find the latitude")
                        return
                    }
                    guard let longitude = coordinate!.longitude as? Double else {
                        print("couldn't find the longitude")
                        return
                    }
                    
                    UdacityUser.sharedInstance.latitude = latitude
                    UdacityUser.sharedInstance.longitude = longitude
                    
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
    
    @IBAction func postAStudentLocation(sender: UIButton) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityUser.sharedInstance.key!)\", \"firstName\": \"\(UdacityUser.sharedInstance.firstName!)\", \"lastName\": \"\(UdacityUser.sharedInstance.lastName!)\",\"mapString\": \"\(textField.text!)\", \"mediaURL\": \"\(linkTextField.text!)\",\"latitude\": \(UdacityUser.sharedInstance.latitude!), \"longitude\": \(UdacityUser.sharedInstance.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)// Handle error…
                return
            }
            print(response)
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            print("I actually posted a location")
            print("{\"uniqueKey\": \"\(UdacityUser.sharedInstance.key!)\", \"firstName\": \"\(UdacityUser.sharedInstance.firstName!)\", \"lastName\": \"\(UdacityUser.sharedInstance.lastName!)\",\"mapString\": \"\(self.textField.text!)\", \"mediaURL\": \"\(self.linkTextField.text!)\",\"latitude\": \(UdacityUser.sharedInstance.latitude!), \"longitude\": \(UdacityUser.sharedInstance.longitude!)}")
        }
        task.resume()

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