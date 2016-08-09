//
//  ParseClient.swift
//  On The Map
//
//  Created by lily on 8/4/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class ParseClient {
    
    var session = NSURLSession.sharedSession()
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var parameterWithLimit = parameters
        parameterWithLimit[ParameterKeys.Limit] = Constants.Limit
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parameterWithLimit, withPathExtension: method))
        request.addValue(ParseAPI.parseAPPID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }

    
    
    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}