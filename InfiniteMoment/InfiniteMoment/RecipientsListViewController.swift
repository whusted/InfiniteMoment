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
        getFriends("begin", completion: { (result) -> Void in
            println("Friends: \(self.friends)")
            self.tableView.reloadData()
        })
        
        self.navigationController!.toolbarHidden = false
        var params = parameters
        let token = Lockbox.stringForKey("authToken")
        println(token)
        if (token != nil) {
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            // TODO: Take to login
        }
        
        super.viewDidLoad()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDatePicker") {
            var picker = segue.destinationViewController as! DatePickerViewController;
            picker.parameters = parameters
            picker.recipients = recipients
        }
    }

}
