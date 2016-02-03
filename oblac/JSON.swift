//
//  JSON.swift
//  oblac
//
//  Created by Radka Mokrá on 21.11.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import Foundation

class JSON {
    var data : AnyObject
    var error_fn: (String) -> Void
    init (data : AnyObject, error_fn: (String) -> Void){
        self.data = data
        self.error_fn = error_fn
    }
    
    init (jsonString : NSString, error_fn: (String) -> Void){
        self.error_fn = error_fn
        var e: NSError?
        var data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        if var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e) as? Dictionary<String, AnyObject> {
                if e != nil {
                    self.data = Dictionary<String, AnyObject>()
                } else {
                    self.data = jsonObj
                }
        } else {
            self.data = Dictionary<String, AnyObject>()
            error_fn("Server returned bad response")
        }
    }
    
    func at (index : NSString) -> JSON {
        if var retdata = self.data as? NSDictionary {
            if retdata[index] != nil {
                return JSON(data: retdata[index]!, error_fn: self.error_fn)
            }
        }
        error_fn("Server returned bad response")
        return self
    }
    
    func at (index : Int) -> JSON {
        if var retdata = self.data as? NSArray {
            return JSON(data: retdata[index], error_fn: self.error_fn)
        }
        error_fn("Server returned bad response")
        return self
    }
    
    func int() -> Int {
        if var retdata = self.data as? Int {
            return retdata
        }
        error_fn("Server returned bad response")
        return 0
    }
    
    func str() -> NSString {
        if var retdata = self.data as? NSString {
            return retdata
        }
        error_fn("Server returned bad response")
        return ""
    }
    
    func bool() -> Bool {
        if var retdata = self.data as? Bool {
            return retdata
        }
        error_fn("Server returned bad response")
        return false
    }
    
    func len() -> Int {
        if var retdata = self.data as? NSArray {
            return retdata.count
        }
        error_fn("Server returned bad response")
        return 0
    }
}