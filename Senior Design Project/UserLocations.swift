//
//  UserLocations.swift
//  Senior Design Project
//
//  Created by Mike Maldonado on 10/21/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import Foundation

struct UserLocations: Codable, CustomStringConvertible {
    var longitude: Double
    var latitude: Double
    
    
    init(longitude: Double, latitude: Double, time: Int) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    var description: String { return "(\(latitude), \(longitude)"}
    
}
