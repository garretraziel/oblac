//
//  LoginViewController.swift
//  oblac
//
//  Created by Jan Sedlák on 24.11.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordSwitch: UISwitch!
    var client: HttpClient?
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loginButton.layer.borderWidth = 2.0
        loginButton.layer.cornerRadius = 5.0
        //loginButton.layer.borderColor = UIColor(rgba: "#125EDF").CGColor
        loginButton.layer.backgroundColor = UIColor(rgba: "#125EDF").CGColor
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pozadi-2.png")!)
        // Do any additional setup after loading the view.
        var username = NSUserDefaults.standardUserDefaults().stringForKey("username")
        var password = NSUserDefaults.standardUserDefaults().stringForKey("password")
        if (username != nil && password != nil) {
            nameInput.text = username!
            passwordInput.text = password!
            passwordSwitch.setOn(true, animated: false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func inputExit(sender: AnyObject) {
        (sender as UITextField).resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginAction(sender: AnyObject) {
        let username = nameInput.text
        let password = passwordInput.text
        if (passwordSwitch.on) {
            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        }
        client = HttpClient(username: username, passwd: password, api_url: "https://api.vpsfree.cz/v1", error_callback: { (error: NSString) -> Void in
            var alert: UIAlertView = UIAlertView(title: "Error", message: "Error during reading from server: \(error)", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
        client!.api("/vpses") {
            (data: String) -> Void in
            var decoded = JSON(jsonString: data, error_fn: self.displayError)
            if decoded.at("status").bool() == true {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("showListSegue", sender: self)
                })
            } else {
                self.displayError("Bad username or password")
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showListSegue") {
            let vc = segue.destinationViewController as ViewController
            vc.client = self.client
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
}
