//
//  ParseLocation.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

struct ParseLocation {
    
    var firstName : String!
    var lastName : String!
    var latitude : Float!
    var longtitude: Float!
    var mediaURL: String!
    var mapString: String!
    var objectId : String!
    var uniqueKey : String!
    var createdAt: String!
    var updatedAt: String!
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.ResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.ResponseKeys.LastName] as? String
        latitude = dictionary[ParseClient.ResponseKeys.Latitude] as? Float
        longtitude = dictionary[ParseClient.ResponseKeys.Longitude] as? Float
        mediaURL = dictionary[ParseClient.ResponseKeys.MediaURL] as? String
        objectId = dictionary[ParseClient.ResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as? String
        mapString = dictionary[ParseClient.ResponseKeys.MapString] as? String
        createdAt = dictionary[ParseClient.ResponseKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.ResponseKeys.UpdatedAt] as? String
    }
    
    init(firstName: String, lastName: String, latitude: Float, longtitude: Float, mediaURL: String, mapString: String, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.longtitude = longtitude
        self.latitude = latitude
        self.mediaURL = mediaURL
        self.mapString = mapString
        self.uniqueKey = uniqueKey
    }
    
    static func locationsFromResult(results: [[String: AnyObject]]) -> [ParseLocation] {
        
        var locations = [ParseLocation]()
        
        for result in results {
            locations.append(ParseLocation(dictionary: result))
        }
        
        return locations
    }

}
