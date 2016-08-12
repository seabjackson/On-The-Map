//
//  ParseConstants.swift
//  On The Map
//
//  Created by lily on 8/5/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    // MARK: Constants 
    struct Constants {
        
        // MARK: URLS

        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let AuthorizationURL = "https://www.udacity.com/account/auth#!/signup"
        static let Limit : String = "100"
    }


        struct ParseAPI {
            static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let parseAPPID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        }
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            static let Limit = "limit"
        }
        
        // MARL: Methods
        struct Methods {
            static let StudentLocation = "/StudentLocation"
        }
        
    
}