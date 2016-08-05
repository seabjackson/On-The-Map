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
            taskForGETMethod(Constants.Methods.AuthenticationSession, jsonBody: jsonBody) { (results, error) in
                if let error = error {
                    print(error)
                    completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID)")
                } else {
                    guard let sessionObject = results["session"] as? [String: AnyObject] else {
                        print("sessionObject error")
                        return
                    }
                    
                    if let sessionID = sessionObject[Constants.JSONResponseKeys.SessionID] as? String {
                        completionHandlerForSession(success: true, sessionID: sessionID, errorString: nil)
                    } else {
                        print("Could not find session id")
                        completionHandlerForSession(success: false, sessionID: nil, errorString: "Login Failed (Session ID)")
                    }
                }
            }
    }

    
}