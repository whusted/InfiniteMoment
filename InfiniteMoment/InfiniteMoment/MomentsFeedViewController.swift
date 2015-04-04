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

let token = Lockbox.stringForKey("authToken")

class MomentsFeedViewController: UITableViewController {
    override func viewDidLoad() {
        println("In Moments Feed")
        super.viewDidLoad()
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
    }
    
    override func viewWillAppear(animated: Bool) {
        println("In view will appear")
        println(token)
        
        Alamofire.request(.GET, "http://localhost:7777/momentsFeed")
        .responseJSON { (request, response, json, error) in
            let json = JSON(json!)
            if (error != nil) {
                NSLog("Error: \(error)")
            } else if (json["error"] != nil) {
                // Invalid auth token; go to login
                println("invalid auth")
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                println("Already logged in")
                println(json)
            }
        }
        super.viewWillAppear(true)
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
