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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var params = parameters
        let token = Lockbox.stringForKey("authToken")
        println(token)
        if (token != nil) {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            // TODO: Take to login
        }
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.friends.count
        }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let item = self.friends[indexPath.row].string
        
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = item
            return cell
    }

}
