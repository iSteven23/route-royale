//
//  UserRoute.swift
//  Senior Design Project
//
//  Created by Mike Maldonado on 10/22/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import Foundation

class Route: Codable, Hashable, CustomStringConvertible{
    
    var hashValue: Int {
        return routeID
    }
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.routeID == rhs.routeID
    }
    private var routeID: Int
    let createdAt: Date
    var routeName: String
    private static var routeIdFactory = -1
    var userLocations = [UserLocations]()
    var time: Int
    var rdescription: String?
    var distance: Double
    var speed: Double
    var userCompleted: Int
    
    init() {
        routeName = "Untitled Route"
        time = 0
        routeID = Route.getUniqueIdentifier()
        speed = 0
        userCompleted = 0
        distance = 0
        createdAt = Date()
    }
    private static func getUniqueIdentifier() -> Int {
        routeIdFactory += 1
        return routeIdFactory
    }
    
    var description:String { return "\(routeName), \(distance), \(speed), \(userCompleted), UserLocations: \(userLocations.count)" } 

    
}
