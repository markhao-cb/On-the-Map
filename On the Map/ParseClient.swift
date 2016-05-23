//
//  ParseClient.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/20/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error : NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = Utilities.BuildURLFrom(ParseClient.Constants.ApiScheme, host: ParseClient.Constants.ApiHost, path: ParseClient.Constants.ApiPath, parameters: parameters, withPathExtension: method)
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: ParseClient.Constants.HeaderField.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.Constants.HeaderField.ApiKey)
        let task = Utilities.session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            Utilities.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error : NSError?) -> Void) -> NSURLSessionDataTask {
        
//        let url = Utilities.BuildURLFrom(ParseClient.Constants.ApiScheme, host: ParseClient.Constants.ApiHost, path: ParseClient.Constants.ApiPath, parameters: parameters, withPathExtension: method)
        let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: ParseClient.Constants.HeaderField.ApplicationID)
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.Constants.HeaderField.ApiKey)
        request.addValue(ParseClient.Constants.JSON, forHTTPHeaderField: ParseClient.Constants.HeaderField.ContentType)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = Utilities.session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            
            Utilities.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        
        return task
    }
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
