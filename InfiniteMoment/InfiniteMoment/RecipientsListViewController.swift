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
    
    var parameters = Dictionary<String, AnyObject>()
    var friends = Array<JSON>()
    var recipients = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.toolbarHidden = false
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = self.friends[indexPath.row]
        println("User: \(user.string!)")
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if (cell.accessoryType == .Checkmark) {
                cell.accessoryType = .None;
                self.recipients = self.recipients.filter( {$0 != user.string!})
                for name in self.recipients {
                    println(name)
                }
            } else {
                cell.accessoryType = .Checkmark
                self.recipients.append(user.string!)
                for name in self.recipients {
                    println(name)
                }
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDatePicker") {
            var picker = segue.destinationViewController as! DatePickerViewController;
            picker.parameters = parameters
            picker.recipients = recipients
        }
    }

}
