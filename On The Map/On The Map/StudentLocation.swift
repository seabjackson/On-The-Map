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
    
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniquekey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
    }
}

struct StudentLocations {
    var sharedLocations = [StudentLocation]()
    static var sharedInstance = StudentLocations()
}




