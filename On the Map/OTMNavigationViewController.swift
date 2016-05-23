//
//  OTMNavigationViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import JCAlertView

class OTMNavigationViewController: UIViewController {
    
    var locations : [ParseLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        getStudentLocations()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension OTMNavigationViewController {
    private func setupNavigationBar() {
        navigationItem.title = "On the Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: #selector(addPin))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .Plain, target: self, action: #selector(getStudentLocations))
    }
}

extension OTMNavigationViewController {
    func addPin() {
        let addPinVC = self.storyboard?.instantiateViewControllerWithIdentifier("addPinViewController") as! AddPinViewController
        self.presentViewController(addPinVC, animated: true, completion: nil)
    }
}

extension OTMNavigationViewController {
    
    @objc private func getStudentLocations() {
        
        let parameters = [
            ParseClient.ParametersKeys.Limit : 100,
            ParseClient.ParametersKeys.Order : "-createdAt"
        ]
        let method = ParseClient.Methods.StudentLocation
        ParseClient.sharedInstance().taskForGETMethod(method, parameters: parameters) { (result, error) in
            performUIUpdatesOnMain({ 
                guard (error == nil) else {
                    
                    showAlertViewWith("Oops!", error: "Failed to get new data. Error: \(error?.domain)", type: .AlertViewWithTwoButtons, firstButtonTitle: "Try again", firstButtonHandler: {
                        self.getStudentLocations()
                        }, secondButtonTitle: "Cancel", secondButtonHandler: nil)
                    return
                }
                
                guard let locations = result[ParseClient.ResponseKeys.Results] as? [[String : AnyObject]] else {
                    
                    showAlertViewWith("Oops!", error: "No location result returned.", type: .AlertViewWithTwoButtons, firstButtonTitle: "Try again", firstButtonHandler: {
                        self.getStudentLocations()
                        }, secondButtonTitle: "Cancel", secondButtonHandler: nil)
                    return
                }
                
                self.locations = ParseLocation.locationsFromResult(locations)
                
                NSNotificationCenter.defaultCenter().postNotificationName(Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
            })
        }
    }
    
    static func postStudentLocationFrom(link: String, location: String) {
        let parameters = [String: AnyObject]()
        let method = ParseClient.Methods.StudentLocation
        let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
    }
}








