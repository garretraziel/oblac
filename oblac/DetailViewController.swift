//
//  DetailViewController.swift
//  oblac
//
//  Created by Radka Mokrá on 21.11.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import Foundation
import UIKit

extension NSTimer {
    class func scheduledTimerWithTimeInterval(interval: NSTimeInterval, repeats: Bool, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let repeatInterval = repeats ? interval : 0
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, repeatInterval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}

class DetailViewController: UIViewController, GCDAsyncSocketDelegate {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var vpsNameLabel: UILabel!
    @IBOutlet weak var vpsIPLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var serverLabel: UILabel!
    
    @IBOutlet weak var sshLabel: UITextField!
    @IBOutlet weak var httpLabel: UITextField!
    @IBOutlet weak var httpsLabel: UITextField!
    @IBOutlet weak var ftpLabel: UITextField!
    @IBOutlet weak var sftpLabel: UITextField!
    @IBOutlet weak var dnsLabel: UITextField!
    @IBOutlet weak var smtpLabel: UITextField!
    @IBOutlet weak var imapLabel: UITextField!
    @IBOutlet weak var popLabel: UITextField!
    
    var vps: Vps?
    var client: HttpClient?
    var bsocket: GCDAsyncSocket?
    var ip: String?
    
    @IBAction func stopVps(sender: AnyObject) {
        if (vps != nil && client != nil) {
            client!.api_post("/vpses/\(vps!.id)/stop")
        }
    }
    
    @IBAction func startVps(sender: AnyObject) {
        if (vps != nil && client != nil) {
            client!.api_post("/vpses/\(vps!.id)/start")
        }
    }
    
    @IBAction func vpsRestart(sender: AnyObject) {
        if (vps != nil && client != nil) {
            client!.api_post("/vpses/\(vps!.id)/restart")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sshLabel.layer.cornerRadius = 5.0
        self.sshLabel.clipsToBounds = true
        self.httpLabel.layer.cornerRadius = 5.0
        self.httpLabel.clipsToBounds = true
        var current_loop = NSRunLoop.currentRunLoop()
        
        if (vps != nil && client != nil) {
            self.logoImage.image = UIImage(named: resolveIcon(vps!.distro))
            client!.api("/vpses/\(vps!.id)/ip_addresses") {
                (data: String) -> Void in
                var json = JSON(jsonString: data, error_fn: self.displayError)
                let ipx = json.at("response").at("ip_addresses").at(0).at("addr").str()
                dispatch_async(dispatch_get_main_queue()) {
                    self.vpsIPLabel.text = ipx
                    self.ip = ipx
                }
                var timer = NSTimer(timeInterval: 10.0, target: self, selector: Selector("us:"), userInfo: nil, repeats: true)
                current_loop.addTimer(timer, forMode: NSRunLoopCommonModes)
            }
            vpsNameLabel.text = vps!.vpsName
            idLabel.text = String(vps!.id)
            serverLabel.text = vps!.server
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        self.us(NSTimer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayError(error: NSString) {
        NSLog(error)
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        NSLog("connected to \(host) \(port)")
    }

    func us(timer: NSTimer) {
        if (self.ip != nil) {
            var services: [(UInt16, UITextField)] = [
                (22, self.sshLabel),
                (80, self.httpLabel),
                (443, self.httpsLabel),
                (22, self.ftpLabel),
                (115, self.sftpLabel),
                (53, self.dnsLabel),
                (25, self.smtpLabel),
                (993, self.imapLabel),
                (110, self.popLabel)
            ]
            for (port, label) in services {
                ServiceObtainer(host: self.ip!, port: port) {
                    (state: Bool) -> Void in
                    if state {
                        dispatch_async(dispatch_get_main_queue()) {
                            label.backgroundColor = UIColor(rgba: "#00E861")
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            label.backgroundColor = UIColor(rgba: "#FD3C2D")
                        }
                    }
                }
            }
        }
    }
    
    func displayError(error: String) {
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = error
        alert.addButtonWithTitle("OK")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            alert.show()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
