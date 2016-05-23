//
//  AddPinViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/22/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    
    //MARK: -Properties
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    
    var postLocationDelegate : PostLocationDelegate?
    
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViewWithIdentifier("addLocationViewController")
    }
    
    //MARK: -IBActions
    @IBAction func cancelAdding(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: ADD Location Delegate Method
extension AddPinViewController : AddLocationDelegate, PostLocationDelegate {
    
    func locationFound(result: MKLocalSearchResponse, fromString: String) {
        let submitLocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("submitLocationViewController") as! SubmitLoactionViewController
        submitLocationVC.postLocationDelegate = self
        submitLocationVC.view.translatesAutoresizingMaskIntoConstraints = false
        submitLocationVC.mapItem = result.mapItems.first
        submitLocationVC.queryString = fromString
        cycleFromViewController(currentViewController!, toViewController: submitLocationVC)
    }
    
    func locationSubmittedWithLocation(location: ParseLocation) {
        if let delegate = self.postLocationDelegate {
            delegate.locationSubmittedWithLocation(location)
            performUIUpdatesOnMain({ 
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
}

//MARK: Switch View Controller Helper Methods
extension AddPinViewController {
    private func addSubview(subView:UIView, toView parentView:UIView) {
        
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    private func setupContainerViewWithIdentifier(identifier: String) {
        
        let addLocationVC = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! AddLocationViewController
        addLocationVC.addLocationDelegate = self
        currentViewController = addLocationVC
        currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: containerView)
    }
    
    private func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.25, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            }, completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
}

protocol PostLocationDelegate {
    func locationSubmittedWithLocation(location: ParseLocation)
}
