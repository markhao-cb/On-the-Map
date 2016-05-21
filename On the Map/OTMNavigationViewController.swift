//
//  OTMNavigationViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class OTMNavigationViewController: UIViewController {
    
    var locations : [ParseLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "On the Map"
        getStudentLocations()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension OTMNavigationViewController {
    
    private func getStudentLocations() {
        
        let parameters = [
            ParseClient.ParametersKeys.Limit : 100,
            ParseClient.ParametersKeys.Order : "-createdAt"
        ]
        let method = ParseClient.Methods.StudentLocation
        ParseClient.sharedInstance().taskForGETMethod(method, parameters: parameters) { (result, error) in
            performUIUpdatesOnMain({ 
                guard (error == nil) else {
                    self.alertError("Failed to get new data. Error: \(error?.domain)")
                    return
                }
                
                guard let locations = result[ParseClient.ResponseKeys.Results] as? [[String : AnyObject]] else {
                    self.alertError("No result returned.")
                    return
                }
                
                self.locations = ParseLocation.locationsFromResult(locations)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
            })
        }
    }
}

extension OTMNavigationViewController {
    
    private func alertError(error: String) {
        
    }
}