//
//  UdacityUser.swift
//  On The Map
//
//  Created by lily on 7/30/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

class UdacityUser {
    var firstName: String?
    var lastName: String?
    var sessionID: String?
    var key: String?
    var latitude: Double?
    var longitude: Double?
    var mediaURL: String?
    
    
    static let sharedInstance = UdacityUser()
}