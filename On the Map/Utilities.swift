//
//  Utilities.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit
import JCAlertView

struct Utilities {
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let session = NSURLSession.sharedSession()
    
    
    //MARK: Methods for Networking
    
    static func BuildURLFrom(scheme: String, host: String, path: String, parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()

        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    static func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    struct NotificationConstants {
        static let LocaltionDataUpdated = "locationDataUpdated"
    }
    
    static let TextFieldPlaceHolderAttr = [
        NSFontAttributeName : UIFont.systemFontOfSize(23),
        NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    
    
    enum AlertViewType {
        case AlertViewWithOneButton
        case AlertViewWithTwoButtons
    }
}

extension UIViewController {
    
    func setupButton(btn: UIButton) {
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
    }
}

//Class Methods

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}

func openUrlFrom(mediaURL: String?) {
    let app = UIApplication.sharedApplication()
    if let toOpen = mediaURL {
        if let url = NSURL(string: toOpen) {
            if app.canOpenURL(url) {
                app.openURL(url)
            } else {
                showAlertViewWith("Oops!", error: "URL is invaild. Please try others.", type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
            }
        }
    }
}

func showAlertViewWith(title: String, error: String, type: Utilities.AlertViewType, firstButtonTitle: String?, firstButtonHandler: (() -> Void)?, secondButtonTitle: String?, secondButtonHandler: (() -> Void)? ) {
    switch type {
    case .AlertViewWithOneButton:
        JCAlertView.showOneButtonWithTitle(title, message: error, buttonType: .Default, buttonTitle: firstButtonTitle, click: firstButtonHandler)
        break
    case .AlertViewWithTwoButtons:
        JCAlertView.showTwoButtonsWithTitle(title, message: error, buttonType: .Default, buttonTitle: firstButtonTitle, click: firstButtonHandler, buttonType: .Cancel, buttonTitle: secondButtonTitle, click: secondButtonHandler)
        break
    }
}

func addProgressIndicatorTo(view: UIView, withAnimation: Bool) {
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
    indicator.center = view.center
    view.addSubview(indicator)
}