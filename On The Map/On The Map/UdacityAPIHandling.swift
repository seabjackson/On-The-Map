//
//  UdacityAPIHandling.swift
//  On The Map
//
//  Created by lily on 7/29/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class UdacityAPIHandling {
    
    static let sharedInstance = UdacityAPIHandling()
    
    
    func getSessionID(username: String, password: String, completionHandlerForLogin: (success: Bool, error: NSError?) -> Void) {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath
        
        print(components.URL!)
        let urlString = NSURL(string: "\(components.URL!)")!
        let request = NSMutableURLRequest(URL: urlString)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            // check for errors
            guard (error == nil) else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            // check for successful 2xx response
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            // check to see if data was returned
            guard let data = data else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            // NEED TO SKIP THE FIRST 5 CHARACTERS OF THE UDACITY JSON RESPONSES
            let range = NSMakeRange(5, data.length - 5)
            let newData = data.subdataWithRange(range)
            
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("data error while parsing")
                return
            }
            print(parsedResult)
            
            // check for an account
            guard let account = parsedResult["account"] as? [String: AnyObject] else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            // is the account registered
            guard let registered = account["registered"] as? Bool where registered == true else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            // get the unique key for the user
            guard let key = account["key"] as? String else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            guard let sessionObject = parsedResult["session"] as? [String: AnyObject] else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            guard let sessionID = sessionObject["id"] as? String else {
                completionHandlerForLogin(success: false, error: error)
                return
            }
            
            print(sessionID)
            print(key)
            UdacityUser.sharedInstance.sessionID = sessionID
            UdacityUser.sharedInstance.key = key
            completionHandlerForLogin(success: true, error: nil)
            
        }
        task.resume()
        
    }
    
    
    
}