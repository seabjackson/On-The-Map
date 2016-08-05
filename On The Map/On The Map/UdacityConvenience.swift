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
                    // check for an account
                    guard let account = results["account"] as? [String: AnyObject] else {
                        print("account error")
                        return
                    }
        
                    // is the account registered
                    guard let registered = account["registered"] as? Bool where registered == true else {
                        print("registered error")
                        return
                    }
                    
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