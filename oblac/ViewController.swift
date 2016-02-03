//
//  ViewController.swift
//  oblac
//
//  Created by Radka Mokrá on 24.10.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate{
    
    @IBOutlet weak var vpsTableView: UITableView!
    var vpses: [Vps] = []
    var client: HttpClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        vpsTableView.tableFooterView = UIView.init(frame: CGRectZero)
        setUpVpses()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpVpses() {
        client!.api("/vpses") {
            (data: String) -> Void in
            var decoded = JSON(jsonString: data, error_fn: self.displayError)
            var vpses = decoded.at("response").at("vpses")
            if vpses.len() != 0 {
                for i in 0...vpses.len()-1 {
                    var name = vpses.at(i).at("hostname").str()
                    var id = vpses.at(i).at("id").int()
                    var distro = vpses.at(i).at("os_template").at("label").str()
                    var server = vpses.at(i).at("node").at("name").str()
                    var vps = Vps(name: name, id: id, distro: distro, server: server)
                    self.vpses.append(vps)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.vpsTableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vpses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: VpsCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("vpsCell") as VpsCellTableViewCell
        let vps = vpses[indexPath.row]
        cell.setCell(vps.vpsName, distro: vps.distro)
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailViewSegue") {
            let selected_index = self.vpsTableView.indexPathForSelectedRow()
            let active_vps = vpses[selected_index!.row]
            let vc = segue.destinationViewController as DetailViewController
            vc.vps = active_vps
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

