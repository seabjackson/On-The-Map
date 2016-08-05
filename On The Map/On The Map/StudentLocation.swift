//
//  StudentLocation.swift
//  On The Map
//
//  Created by lily on 8/1/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
}

struct StudentLocations {
    var sharedLocations = [StudentLocation]()
    static let sharedInstance = StudentLocations()
}
