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

class MomentsFeedViewController: UIViewController {
    override func viewDidLoad() {
        println("In Moments Feed")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("In view will appear")
        // let token = Lockbox.stringForKey("authToken")
        // if token is nil, go to login
        let token = "303943" // Not ever valid
        let URL = NSURL(string: "http://localhost:7777/momentsFeed")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        let manager = Alamofire.Manager.sharedInstance
        let request = manager.request(mutableURLRequest)
        request.responseString { (request, response, json, error) in
            let json = JSON(json!)
            if (error != nil) {
                NSLog("Error: \(error)")
            } else if (json["error"] != nil) {
                // Invalid auth token; go to login
                println("invalid auth")
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                println(json)
                println(json["error"])
            }
        }
        super.viewWillAppear(true)
    }
}
