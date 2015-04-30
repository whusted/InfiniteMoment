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
    var username = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let token = Lockbox.stringForKey("authToken")
        println(token)
        if (token != nil) {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
        self.tableView.reloadData()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        getMoments("begin", completion: { (result) -> Void in
            println("Moments after getting them: \(self.moments)")
            self.username = Lockbox.stringForKey("username")
            self.tableView.reloadData()
        })
    }
    
    func getMoments(input: String, completion: (result: Bool) -> Void) {
        Alamofire.request(.GET, "http://localhost:7777/momentsFeed")
            .responseJSON { (request, response, json, error) in
                if (json != nil) {
                    let json = JSON(json!)
                    if (error != nil) {
                        NSLog("Error: \(error)")
                    } else if (json["error"] != nil) {
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
        return self.moments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let content = self.moments[indexPath.row]["content"].string
        let author : String
        if (self.moments[indexPath.row]["author"].string == self.username) {
            author = "Yourself"
        } else {
            author = self.moments[indexPath.row]["author"].string!
        }
        let result = author + ": " + content!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = result
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
