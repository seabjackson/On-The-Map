//
//  UdacityUser.swift
//  On The Map
//
//  Created by lily on 7/30/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class UdacityUser {
    var firstName: String? = nil
    var lastName: String? = nil
    var sessionID: String? = nil
    var key: String? = nil
    
    static let sharedInstance = UdacityUser()
}