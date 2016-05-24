//
//  UDConvenience.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit


// MARK: -Methods for login
extension UDClient {
    
    func authenticateWithUsernameAndPassword(username:String, password:String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        getSessionIDWithUsernameAndPassword(username, password: password) { (success, sessionID, userID, errorString) in
            if success {
                print("Get SessionID and UserID Successfully. \n SessionID: \(sessionID!) \n UserID: \(userID!)")
                UDClient.sharedInstance().sessionID = sessionID
                UDClient.sharedInstance().userID = userID
                
                self.getUserInfoFromUserID(userID!, completionHandlerForUserId: { (success, firstName, lastName, errorMessage) in
                    if success {
                        UDClient.sharedInstance().firstName = firstName!
                        UDClient.sharedInstance().lastName = lastName!
                        
                        print("Login Successfully. \n Logging in as: \(firstName!) \(lastName!)")
                        completionHandlerForAuth(success: true, errorString: nil)
                    }
                })
                
                
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
        
    }
    
    private func getSessionIDWithUsernameAndPassword(username: String, password: String, completionHandlerForSessionId: (success: Bool, sessionID: String?, userID: String?,  errorString: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let method = UDClient.Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        UDClient.sharedInstance().taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (result, error) in
        
                guard (error == nil) else {
                    completionHandlerForSessionId(success: false, sessionID: nil, userID: nil, errorString: "Login Failed. (Error: \(error!.domain)")
                    return
                }
                
                guard let session = result[UDClient.ResponseKeys.Session] as? [String: AnyObject], sessionId = session[UDClient.ResponseKeys.SessionId] as? String else {
                    completionHandlerForSessionId(success: false, sessionID: nil, userID: nil, errorString: "Login Failed. (Get session ID).")
                    return
                }
                
                guard let account = result[UDClient.ResponseKeys.Account] as? [String: AnyObject], userID = account[UDClient.ResponseKeys.Key] as? String else {
                    completionHandlerForSessionId(success: false, sessionID: nil, userID: nil, errorString: "Login Failed. (Get User ID).")
                    return
                }
            
            completionHandlerForSessionId(success: true, sessionID: sessionId, userID: userID, errorString: nil)
            
        }
        
    }
    
    private func getUserInfoFromUserID(userID: String, completionHandlerForUserId: (success: Bool, firstName: String?, lastName: String?, errorMessage: String?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let method = "\(UDClient.Methods.Users)/\(userID)"
        UDClient.sharedInstance().taskForGETMethod(method, parameters: parameters) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForUserId(success: false, firstName: nil, lastName: nil, errorMessage: "Get User Info Failed. Error: \(error?.domain)")
                return
            }
            
            guard let user = result[UDClient.ResponseKeys.User] as? [String: AnyObject], firstName = user[UDClient.ResponseKeys.FirstName] as? String, lastName = user[UDClient.ResponseKeys.LastName] as? String else {
                completionHandlerForUserId(success: false, firstName: nil, lastName: nil, errorMessage: "Get user firstname or lastname Failed.")
                return
            }
            
            completionHandlerForUserId(success: true, firstName: firstName, lastName: lastName, errorMessage: nil)
        }
        
        
    }
}


//MARK: -Methods for logout
extension UDClient {
    
    func logoutCurrentSession(completionHandlerForLogout: (success: Bool, errorMessage: String?) -> Void) {
        let parameters = [String: AnyObject]()
        let method = UDClient.Methods.Session
        UDClient.sharedInstance().taskForDELETEMethod(method, parameters: parameters) { (result, error) in
            
            guard (error == nil) else {
                completionHandlerForLogout(success: false, errorMessage: "Logout failed. Error: \(error?.domain)")
                return
            }
            
            UDClient.sharedInstance().firstName = nil
            UDClient.sharedInstance().lastName = nil
            UDClient.sharedInstance().sessionID = nil
            UDClient.sharedInstance().userID = nil
            
            completionHandlerForLogout(success: true, errorMessage: nil)
        }
        
    }
    
    
}