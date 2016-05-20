//
//  UDConvenience.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit

extension UDClient {
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
    }
    
    private func getSessionID(completionHandlerForSessionId: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        let parameters = [String : AnyObject]()
        
    }
}