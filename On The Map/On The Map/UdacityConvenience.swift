//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by lily on 8/3/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension UdacityClient {
    func getSessionID(username: String, password: String, completionHandlerForSession: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
            let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPOSTMethod(Constants.Methods.AuthenticationSession, jsonBody: jsonBody, methodType: "POST") { (results, error) in
                if let error = error {
                    print(error)
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID)")
                } else {
                    guard let sessionObject = results["session"] as? [String: AnyObject] else {
                        print("sessionObject error")
                        return
                    }
                    print(results)
                    
                    if let sessionID = sessionObject[Constants.JSONResponseKeys.SessionID] as? String {
                        completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                    } else {
                        print("Could not find session id")
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID)")
                    }
                }
            }
    }
    
    func deleteSessionID(completionHandlerForSession: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
//            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
//            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            completionHandlerForSession(success: true, errorString: nil)
        }
        task.resume()
    }
    
    

    
}