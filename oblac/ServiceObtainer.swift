//
//  ServiceObtainer.swift
//  oblac
//
//  Created by Jan Sedlák on 02.12.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import Foundation

class ServiceObtainer: NSObject, GCDAsyncSocketDelegate {
    var bsocket: GCDAsyncSocket?
    var callback: (Bool) -> Void
    var s: ServiceObtainer?
    
    init(host: String, port: UInt16, callback: (Bool) -> Void) {
        self.callback = callback
        super.init()
        self.s = self
        
        bsocket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        var e: NSError?
        if (!self.bsocket!.connectToHost(host, onPort: port, withTimeout: 10.0, error: &e)) {
            NSLog("\(e)")
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        sock.disconnect()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        if err != nil {
            callback(false)
        } else {
            callback(true)
        }
    }
}