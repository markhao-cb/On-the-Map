//
//  UDClient.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

class UDClient: NSObject {
    
    // MARK: Properties
    
    // authentication state
    var sessionID : String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = Utilities.BuildURLFrom(UDClient.Constants.ApiScheme, host: UDClient.Constants.ApiHost, path: UDClient.Constants.ApiPath, parameters: parameters, withPathExtension: method)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = Utilities.session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            Utilities.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UDClient {
        struct Singleton {
            static var sharedInstance = UDClient()
        }
        return Singleton.sharedInstance
    }
    
    
}