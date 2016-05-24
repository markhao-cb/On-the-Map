//
//  FBConvenience.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/24/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

struct FBNetworking {
    static func fetchProfile(completionHandlerForFetch:(success: Bool) -> Void) {
        let parameters = [
            "field" : "first_name, last_name"
        ]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            
            guard (error == nil) else {
                return
            }
        }
    }
}