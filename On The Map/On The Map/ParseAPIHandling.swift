//
//  ParseAPIHandling.swift
//  On The Map
//
//  Created by lily on 8/1/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

//import Foundation
//
//class ParseAPIHandling {
//    
//    static let sharedInstance = ParseAPIHandling()
//    
//    func getStudentLocation(completionHandlerForStudentLocation: (success: Bool, error: NSError?) -> Void) {
//        
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
//        request.addValue(Constants.ParseAPI.parseAPPID, forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue(Constants.ParseAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error...
//                return
//            }
//             print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//            var parsedData: AnyObject!
//            do {
//                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
//            } catch {
//                return
//            }
//            print(parsedData)
//        }
//        task.resume()
//
//    }
//    
//    
//}