//
//  OTMNavigationViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: #selector(addPin))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(logoutCurrentSession))
    }
}

extension OTMNavigationViewController : PostLocationDelegate {
    func addPin() {
        if checkIfAlreadyPosted() {
            showAlertViewWith("Warning", error: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", type: .AlertViewWithTwoButtons, firstButtonTitle: "Overwrite", firstButtonHandler: { 
                    performUIUpdatesOnMain({ 
                       self.createAddPinVC()
                    })
                }, secondButtonTitle: "Cancel", secondButtonHandler: nil)
        } else {
            createAddPinVC()
        }
    }
    
    func locationSubmittedWithLocation(location: ParseLocation) {
        postStudentLocationFrom(location)
    }
}


//MARK: -Networking Methods
extension OTMNavigationViewController {
    
    private func getStudentLocations() {
        
        NVActivityIndicatorView.showHUDAddedTo(view)
        ParseClient.sharedInstance().getStudentLocation { (success, locations, errorMessage) in
            performUIUpdatesOnMain({
                NVActivityIndicatorView.hideHUDForView(self.view)
                if success {
                    self.locations = ParseLocation.locationsFromResult(locations!)
                    NSNotificationCenter.defaultCenter().postNotificationName(Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
                } else {
                    showAlertViewWith("Oops!", error: errorMessage!, type: .AlertViewWithTwoButtons, firstButtonTitle: "Try again", firstButtonHandler: {
                            self.getStudentLocations()
                        }, secondButtonTitle: "Cancel", secondButtonHandler: nil)
                }
            })
        }
    }
    
    func postStudentLocationFrom(location: ParseLocation) {
        
        NVActivityIndicatorView.showHUDAddedTo(view)
        ParseClient.sharedInstance().postStudentLocationWithLocation(location) { (success, errorMessage) in
            performUIUpdatesOnMain({
                NVActivityIndicatorView.hideHUDForView(self.view)
                if success {
                    showAlertViewWith("Yeah!", error: "You just posted your location!", type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
                    self.locations?.insert(location, atIndex: 0)
                    NSNotificationCenter.defaultCenter().postNotificationName(Utilities.NotificationConstants.LocaltionDataUpdated, object: nil)
                } else {
                    showAlertViewWith("Oops!", error: errorMessage!, type: .AlertViewWithTwoButtons, firstButtonTitle: "Try again", firstButtonHandler: {
                        self.addPin()
                        }, secondButtonTitle: "Cancel", secondButtonHandler: nil)
                }
            })
        }
    }
    
    func logoutCurrentSession() {
        showAlertViewWith("Wait...", error: "Are You Sure to Logout?", type: .AlertViewWithTwoButtons, firstButtonTitle: "Yes", firstButtonHandler: {
                UDClient.sharedInstance().logoutCurrentSession({ (success, errorMessage) in
                    performUIUpdatesOnMain({
                        print("Logout Successfully")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            }, secondButtonTitle: "No", secondButtonHandler: nil
        )
    }
}

//MARK: -Helper methods
extension OTMNavigationViewController {
    private func checkIfAlreadyPosted() -> Bool {
        if let locations = locations {
            for location in locations {
                if UDClient.sharedInstance().userID! == location.uniqueKey {
                    return true
                }
            }
        }
        return false
    }
    
    private func createAddPinVC() {
        let addPinVC = self.storyboard?.instantiateViewControllerWithIdentifier("addPinViewController") as! AddPinViewController
        addPinVC.postLocationDelegate = self
        self.presentViewController(addPinVC, animated: true, completion: nil)
    }
}







