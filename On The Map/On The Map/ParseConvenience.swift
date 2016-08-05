//
//  ParseConvenience.swift
//  On The Map
//
//  Created by lily on 8/5/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocation(completionHandlerForStudentLocation: (success: Bool, studentLocation: [StudentLocation]?, error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForStudentLocation(success: false, studentLocation: nil, error: error)
            } else {
                print(results)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}