//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/23/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation


extension ParseClient {
    
    func getStudentLocation(completionHandlerForGetLocation: (success: Bool, locations: [[String: AnyObject]]?, errorMessage: String?) -> Void) {
        
        let parameters = [
            ParseClient.ParametersKeys.Limit : 100,
            ParseClient.ParametersKeys.Order : "-updatedAt"
        ]
        let method = ParseClient.Methods.StudentLocation
        ParseClient.sharedInstance().taskForGETMethod(method, parameters: parameters) { (result, error) in
            
                guard (error == nil) else {
                    completionHandlerForGetLocation(success: false, locations: nil, errorMessage: "Failed to get new data. Error: \(error?.domain)")
                    return
                }
                
                guard let locations = result[ParseClient.ResponseKeys.Results] as? [[String : AnyObject]] else {
                    completionHandlerForGetLocation(success: false, locations: nil, errorMessage:  "No location result returned.")
                    return
                }
                completionHandlerForGetLocation(success: true, locations: locations, errorMessage: nil)
        }
    }
    
    func postStudentLocationWithLocation(location: ParseLocation, completionHandlerForPostLocation: (success: Bool, errorMessage: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let method = ParseClient.Methods.StudentLocation
        let jsonBody = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longtitude)}"
        
        taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForPostLocation(success: false, errorMessage: "Failed to post location. Error: \(error?.domain)")
                return
            }
            completionHandlerForPostLocation(success: true, errorMessage: nil)
        }
        
    }
    
    
    
}
