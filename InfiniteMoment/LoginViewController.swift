//
//  LoginViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 3/31/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Security
import Lockbox

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(sender: AnyObject) {
        
        let loginParameters = [
            "username": username.text,
            "password": password.text
        ]
        
        Alamofire.request(.POST, "http://localhost:7777/sessions", parameters: loginParameters, encoding: .JSON)
            .responseJSON {(request, response, json, error) in
                var resp = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (resp["error"] != nil) {
                    var alert = UIAlertController(title: "Oops!", message: resp["message"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    println(resp["response"])
                    let token = Lockbox.setString(resp["token"].string, forKey: "authToken")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
        }
    }

}
