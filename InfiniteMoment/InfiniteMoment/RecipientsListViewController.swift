//
//  RecipientsListViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/17/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Lockbox
import Alamofire
import SwiftyJSON
import Security

class RecipientsListViewController: UITableViewController {
    
    var parameters = Dictionary<String, String>()
    var friends = Array<JSON>()
    let fakeFriends = ["thisGuy", "thatGuy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var params = parameters
        println(params)
        
        let token = Lockbox.stringForKey("authToken")
        println(token)
        if (token != nil) {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            // TODO: Take to login
        }
        
        getFriends("begin", completion: { (result) -> Void in
            println(self.friends)
        })
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            println(self.friends.count)
            return self.friends.count
        }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let item = self.friends[indexPath.row].string
        
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = item
            return cell
    }
    

    func getFriends(input: String, completion: (result: Bool) -> Void) {
        Alamofire.request(.GET, "http://localhost:7777/friends")
            .responseJSON { (request, response, json, error) in
                let json = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (json["error"] != nil) {
                    // TODO: handle error
                } else {
                    self.friends = json["response"].arrayValue
                    println(self.friends)
                    completion(result: true)
                }
        }
    }
}
