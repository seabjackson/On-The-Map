//
//  StudentLocation.swift
//  On The Map
//
//  Created by lily on 8/1/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
}

struct StudentLocations {
    var sharedLocations = [StudentLocation]()
    static var sharedInstance = StudentLocations()
}
