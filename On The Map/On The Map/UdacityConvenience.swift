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
                if error != nil {
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "failed network connection")
                } else {
                    guard let sessionObject = results["session"] as? [String: AnyObject] else {
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "invalid username/password")
                        return
                    }
                    
                    
                    guard let accountDict = results["account"] as! NSDictionary? else {
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "invalid account")
                        return
                        
                    }
                    
                    guard let registered = accountDict["registered"] as? Int else {
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "account not registered")
                        return
                    }
                    
                    guard let key = accountDict["key"] as? String else {
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "no account key found")
                        return
                    }
                    
                    if registered == 1 {
                        UdacityUser.sharedInstance.key = key
                        self.getUserInfo(key)
                    }
                    
                    
                    if let sessionID = sessionObject[Constants.JSONResponseKeys.SessionID] as? String {
                        completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                    } else {
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "Couldn't find Session ID")
                    }
                }
            }
    }
    
    // delete the sessionID for logging out
    func deleteSessionID(completionHandlerForSession: (success: Bool, errorString: String?) -> Void) {
        let method = Constants.Methods.AuthenticationSession
        let request = NSMutableURLRequest(URL: udacityURL(method))
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
            completionHandlerForSession(success: true, errorString: nil)
        }
        task.resume()
    }
    
    // get user info with unique key so that we can post a location with the correct udacity profile
    func getUserInfo(uniqueKey: String) {
        let uniqueKey = UdacityUser.sharedInstance.key
        taskForPOSTMethod(Constants.Methods.Users + uniqueKey!, jsonBody: nil, methodType: nil) { (results, error) in
            if (results != nil) {
                guard let accountDict = results["user"] as? NSDictionary else {
                    return
                }
                    
                if let firstName = accountDict["first_name"] as? String, lastName = accountDict["last_name"] as? String {
                    UdacityUser.sharedInstance.firstName = firstName
                    UdacityUser.sharedInstance.lastName = lastName
                }
            }
        }
    }

}