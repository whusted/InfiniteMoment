//
//  FriendsListViewController.swift
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

class FriendsListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var friends = Array<JSON>()
    var usersSearched = Array<JSON>()
    
    var searchActive: Bool!
    var usersFound: Bool!
    let token = Lockbox.stringForKey("authToken")
    
    
    override func viewDidLoad() {
        searchActive = false
        usersFound = false
        if (token != nil) {
            println("not nil")
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token]
        } else {
            // TODO: Take to login
        }
        
        println("In Friends List")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("Token: \(self.token)")
        getFriends("begin", completion: { (result) -> Void in
            println("Friends: \(self.friends)")
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive! && usersFound! && self.usersSearched.count != 0) {
            return self.usersSearched.count
        }
        return self.friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        if (searchActive! && usersFound! && self.usersSearched.count != 0) {
            let item = self.usersSearched[indexPath.row].string
            cell.textLabel!.text = item
        } else {
            let item = self.friends[indexPath.row].string
            cell.textLabel!.text = item
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (searchActive! && usersFound! && self.usersSearched.count != 0) {
            let user = self.usersSearched[indexPath.row]
            println("User: \(user.string!)")
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if (cell.accessoryType == .Checkmark) {
                    // TODO: ADD UNFRIEND TO API
                    // cell.accessoryType = .None;
                } else {
                    cell.accessoryType = .Checkmark
                }
            }
            addFriend(user.string!)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("begin editing")
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        println("done editing")
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("cancelled")
        searchActive = false
        getFriends("begin", completion: { (result) -> Void in
            println("Friends: \(self.friends)")
            self.tableView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search button clicked")
        searchActive = false
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token, "search": searchText]
        println(Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders)
        println("Search text \(searchText)")
        if (searchActive!) {
            println("search is active")
            searchForUsers("begin", completion: { (result) -> Void in
                println("Searched results: \(self.usersSearched)")
                self.usersFound = true
                self.tableView.reloadData()
            })
        }
        self.tableView.reloadData()
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
    
    func searchForUsers(input: String, completion: (result: Bool) -> Void) {
        Alamofire.request(.GET, "http://localhost:7777/users")
            .responseJSON { (request, response, json, error) in
                println(request)
                println(response)
                println(json)
                let json = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (json["error"] != nil) {
                    // TODO: handle error
                } else {
                    self.usersSearched = json["response"].arrayValue
                    completion(result: true)
                }
        }
    }
    
    func addFriend(newFriend: String) {
        Alamofire.request(.POST, "http://localhost:7777/friends", parameters: ["Authorization": self.token, "newFriend": newFriend], encoding: .JSON)
            .responseJSON {(request, response, json, error) in
                var resp = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (resp["error"] != nil) {
                    var alert = UIAlertController(title: "Yay!", message: resp["message"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    println(resp["response"])
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
        }

    }

}
