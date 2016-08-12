//
//  UdacityClient.swift
//  On The Map
//
//  Created by lily on 8/3/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID: String?
    var userID: Int?
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForPOSTMethod(method: String, jsonBody: String?, methodType: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // build the url and configure the request
        let request = NSMutableURLRequest(URL: udacityURL(method))
        request.HTTPMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jsonBody = jsonBody {
           request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding) 
        }
        

        // make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // check for errors
            guard (error == nil) else {
                completionHandlerForGET(result: false, error: error)
                return
            }
            
            // check for successful 2xx response
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGET(result: false, error: error)
                return
            }
            
            // check to see if data was returned
            guard let data = data else {
                completionHandlerForGET(result: false, error: error)
                return
            }
            
            // NEED TO SKIP THE FIRST 5 CHARACTERS OF THE UDACITY JSON RESPONSES
            let range = NSMakeRange(5, data.length - 5)
            let newData = data.subdataWithRange(range)
        
            
             // parse the data and use the data
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)

        }
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
//    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
//        
//    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?)  -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    private func udacityURL(withPathExtension: String?) -> NSURL {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath + (withPathExtension ?? "")
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
