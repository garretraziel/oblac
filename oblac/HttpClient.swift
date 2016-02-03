//
//  HttpClient.swift
//  oblac
//
//  Created by Radka Mokrá on 21.11.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import Foundation

class HttpClient {
    var username, passwd, api_url: NSString
    var error_callback: (NSString) -> Void
    init (username: NSString, passwd: NSString, api_url: NSString, error_callback: (NSString) -> Void) {
        self.username = username
        self.passwd = passwd
        self.api_url = api_url
        self.error_callback = error_callback
    }
    
    func api(api_str: NSString, callback: (String) -> Void) {
        self.get(self.api_url + api_str) {
            (data: String, error: String?) -> Void in
            if (error != nil) {
                self.error_callback(error!)
            } else {
                callback(data)
            }
        }
    }
    
    func api_post(api_str: NSString) {
        self.post(self.api_url + api_str) {
            (data: String, error: String?) -> Void in
            if (error != nil) {
                self.error_callback(error!)
            }
        }
    }
    
    func sendRequest(session: NSURLSession, request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if error != nil {
                    callback("", error.localizedDescription)
                } else {
                    var ret_value = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //NSLog("\(ret_value)")
                    callback(ret_value!, nil)
                }
            }
            
            task.resume()
    }
    
    
    func get(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let loginString = "\(self.username):\(self.passwd)"
        let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = NSString(data: loginData.base64EncodedDataWithOptions(nil), encoding: NSUTF8StringEncoding)!
        let authString = "Basic \(base64LoginString)"
        config.HTTPAdditionalHeaders = ["Authorization": authString]
        let session = NSURLSession(configuration: config)
        sendRequest(session, request: request, callback)
    }
    
    func post(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let loginString = "\(self.username):\(self.passwd)"
        let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = NSString(data: loginData.base64EncodedDataWithOptions(nil), encoding: NSUTF8StringEncoding)!
        let authString = "Basic \(base64LoginString)"
        config.HTTPAdditionalHeaders = ["Authorization": authString]
        let session = NSURLSession(configuration: config)
        sendRequest(session, request: request, callback)
    }
}