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
    
    var searchActive: Bool!
    let token = Lockbox.stringForKey("authToken")
    
    
    override func viewDidLoad() {
        searchActive = false
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
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search button clicked")
        searchActive = false
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
                    self.friends = json["response"].arrayValue
                    println(self.friends)
                    completion(result: true)
                }
        }
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": token, "search": searchText]
        println(Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders)
        println("Search text \(searchText)")
        if (searchActive!) {
            println("search is active")
            searchForUsers("begin", completion: { (result) -> Void in
                println("Friends: \(self.friends)")
            })
        }
        self.tableView.reloadData()
    }


}
