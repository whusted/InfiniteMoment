//
//  MomentsFeedViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/3/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Security
import Lockbox

class MomentsFeedViewController: UITableViewController {
    var moments = Array<JSON>()
    override func viewDidLoad() {
        let token = Lockbox.stringForKey("authToken")
        println(token)
        if (token != nil) {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
        
        // TODO: get moments before loading table cells
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        getMoments("begin", completion: { (result) -> Void in
            println("Moments after getting them: \(self.moments)")
            self.tableView.reloadData()
        })
        println("In Moments Feed")
        super.viewDidLoad()
    }
    
    func getMoments(input: String, completion: (result: Bool) -> Void) {
        Alamofire.request(.GET, "http://localhost:7777/momentsFeed")
            .responseJSON { (request, response, json, error) in
                if (json != nil) {
                    let json = JSON(json!)
                    if (error != nil) {
                        NSLog("Error: \(error)")
                    } else if (json["error"] != nil) {
                        // Invalid auth token; go to login
                        println("invalid auth")
                        self.performSegueWithIdentifier("showLogin", sender: self)
                    } else {
                        println("Already logged in")
                        self.moments = json["response"].arrayValue
                        completion(result: true)
                    }
                } else {
                    // TODO: Handle server error
                    var alert = UIAlertController(title: "Uh Oh", message: "Server not connected", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Moments in table view: \(self.moments)")
        return self.moments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = self.moments[indexPath.row].string
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = item
        return cell
    }
    
    @IBAction func logout(sender: AnyObject) {
        Alamofire.request(.DELETE, "http://localhost:7777/sessions")
        .responseJSON { (request, response, json, error) in
            let json = JSON(json!)
            if (error != nil) {
                NSLog("Error: \(error)")
            } else {
                println(json)
                self.performSegueWithIdentifier("showLogin", sender: self)
            }
        }
    }
}