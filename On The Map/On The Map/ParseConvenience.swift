//
//  ParseConvenience.swift
//  On The Map
//
//  Created by lily on 8/5/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocation(completionHandlerForStudentLocation: (success: Bool, error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        taskForGetMethod(Constants.Methods.StudentLocation, parameters: parameters) { (results, error) in
            if let error = error {
                completionHandlerForStudentLocation(success: false, error: error)
            } else {
                guard let locations = results["results"] as? [[String: AnyObject]] else {
                   completionHandlerForStudentLocation(success: false, error: error)
                    return
                }
                // clear out any previous location objects
                StudentLocations.sharedInstance.sharedLocations.removeAll()
                // loop through all the student locations
                for dictionary in locations {
                    let studentLocation = StudentLocation(dictionary: dictionary)
                    
                    // load up the student location array
                    StudentLocations.sharedInstance.sharedLocations.append(studentLocation)
                }
                completionHandlerForStudentLocation(success: true, error: nil)
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
}