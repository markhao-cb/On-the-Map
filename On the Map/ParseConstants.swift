//
//  ParseConstants.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        // MARK: URLs
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
        static let JSON = "application/json"
        
        struct HeaderField {
            static let ApplicationID = "X-Parse-Application-Id"
            static let ApiKey = "X-Parse-REST-API-Key"
            static let ContentType = "Content-Type"
        }
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParametersKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    struct ResponseKeys {
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
        static let MapString = "mapString"
        static let ObjectID = "objectId"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
    }
}
