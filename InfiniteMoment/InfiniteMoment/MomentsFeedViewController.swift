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
    override func viewDidLoad() {
        println("In Moments Feed")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("In view will appear")
        let token = Lockbox.stringForKey("authToken")
        // if token is nil, go to login
        //let token = "aef0ceb0-d96c-11e4-8a34-bfe74b464e28" // Hardcoded BS
        let URL = NSURL(string: "http://localhost:7777/momentsFeed")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseJSON { (request, response, json, error) in
            let json = JSON(json!)
            if (error != nil) {
                NSLog("Error: \(error)")
            } else if (json["error"] != nil) {
                // Invalid auth token; go to login
                println("invalid auth")
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                println("Logged in")
                println(json)
            }
        }
        //super.viewWillAppear(true)
    }
}
