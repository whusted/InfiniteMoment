//
//  SignUpViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/1/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lockbox
import Security

class SignUpViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBAction func signup(sender: AnyObject) {
        
        let signupParameters = [
            "username": username.text,
            "password": password.text,
            "confirmPassword": confirmPassword.text,
            "phone": phoneNumber.text
        ]
        
        Alamofire.request(.POST, "http://localhost:7777/signup", parameters: signupParameters, encoding: .JSON)
            .responseJSON {(request, response, json, error) in
                var resp = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (resp["error"] != nil) {
                    var alert = UIAlertController(title: "Oops!", message: resp["message"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    Alamofire.request(.POST, "http://localhost:7777/sessions", parameters: ["username": self.username.text, "password": self.password.text], encoding: .JSON)
                        .responseJSON {(request, response, json, error) in
                            var resp = JSON(json!)
                            if (error != nil) {
                                NSLog("Error: \(error)")
                            } else {
                                println(resp["response"])
                                let token = Lockbox.setString(resp["token"].string, forKey: "authToken")
                                // Add self to friend list
                                Alamofire.request(.POST, "http://localhost:7777/friends", parameters: ["Authorization": resp["token"].string!, "newFriend": self.username.text], encoding: .JSON)
                                    .responseJSON {(request, response, json, error) in
                                        var resp = JSON(json!)
                                        if (error != nil) {
                                            NSLog("Error: \(error)")
                                        } else if (resp["error"] != nil) {
                                            println("should never happen")
                                        } else {
                                            self.navigationController?.popToRootViewControllerAnimated(true)
                                        }
                                }
                            }
                        
                    }
                }
        }
        
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
