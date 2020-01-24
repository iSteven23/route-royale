//
//  UserRoute.swift
//  Senior Design Project
//
//  Created by Mike Maldonado on 10/22/18.
//  Copyright © 2018 Aaron Dahlin. All rights reserved.
//

import Foundation
import CoreLocation
import os.log

class Route: NSObject, NSCoding {
    
    //MARK: Types
    
    //Static strings used when saving and loading routes in Storage.swift
    struct PropertyKey{
        static let id = "id"
        static let name = "name"
        static let coordinates = "coordinates"
        static let distance = "distance"
        static let time = "time"
        static let description = "description"
    }
    
    /*var hashValue: Int {
        return routeID
    }*/
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.routeID == rhs.routeID
    }
    
    private static var routeIdFactory = -1
    
    //MARK: Properties
    
    private var routeID: Int
    //var userLocations = [UserLocations]()
    var coordinates = [Coordinate]()
    //let startTime: TimeInterval
    //let endTime: TimeInterval?
    var routeName: String
    var time: Double
    var distance: Double
    var rdescription: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("routes")
    
    //MARK: Initializers
    
    override init() {
        //endTime = nil
        routeID = Route.getUniqueIdentifier()
        routeName = "Default Name"
        time = 0
        //TODO: Implement distance calculation
        distance = 0;
        
    }
    
    init(withId id: Int, withName name: String, withLocations locations: [Coordinate], forTime ttime: Double){
        routeID = id
        routeName = name
        coordinates = locations
        time = ttime
        //TODO: Implement distance calculation
        distance = 0;
    }
    
    private static func getUniqueIdentifier() -> Int {
        routeIdFactory += 1
        return routeIdFactory
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(routeID, forKey: PropertyKey.id)
        aCoder.encode(routeName, forKey: PropertyKey.name)
        aCoder.encode(coordinates, forKey: PropertyKey.coordinates)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(distance, forKey: PropertyKey.distance)
        aCoder.encode(rdescription, forKey: PropertyKey.description)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        
        let id = aDecoder.decodeCInt(forKey: PropertyKey.id)
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name of the Route object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let coordinates = aDecoder.decodeObject(forKey: PropertyKey.coordinates) as? [Coordinate] else {
            os_log("Unable to decode the locations of the Route object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let time = aDecoder.decodeDouble(forKey: PropertyKey.time)
        
        //Self init call
        self.init(withId: Int(id), withName: name, withLocations: coordinates, forTime: time)
        
    }
}
