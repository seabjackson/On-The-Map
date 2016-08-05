//
//  Constants.swift
//  On The Map
//
//  Created by lily on 7/28/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation
import UIKit


extension UdacityClient {
    

// MARK: - Constants

    struct Constants {
        
            // MARK: URLS
            struct Udacity {
                static let ApiScheme = "https"
                static let ApiHost = "www.udacity.com"
                static let ApiPath = "/api"
                static let AuthorizationURL = "https://www.udacity.com/account/auth#!/signup"
            }
            
            // MARK: Parameter Keys
            struct ParameterKeys {
                static let ApiKey = "api_key"
                static let SessionID = "session_id"
            }
            
            // MARL: Methods
            struct Methods {
                static let AuthenticationSession = "/session"
            }
            
//            
//            struct ParseAPI {
//                static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
//                static let parseAPPID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
//            }
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            
            // MARK: General
            static let StatusMessage = "status_message"
            static let StatusCode = "status_code"
            
            // MARK: Authorization
            static let RequestToken = "request_token"
            static let SessionID = "id"
            
            // MARK: Account
            static let UserID = ""
        }

    }
}
