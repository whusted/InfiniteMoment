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

class SignUpViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBAction func signup(sender: AnyObject) {
        
        let parameters = [
            "username": username.text,
            "password": password.text,
            "confirmPassword": confirmPassword.text,
            "phone": phoneNumber.text
        ]
        
        Alamofire.request(.POST, "http://localhost:7777/signup", parameters: parameters, encoding: .JSON)
            .responseJSON {(request, response, json, error) in
                var resp = JSON(json!)
                if (error != nil) {
                    NSLog("Error: \(error)")
                } else if (resp["error"] != nil) {
                    var alert = UIAlertController(title: "Oops!", message: resp["message"].string, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                println(resp["error"])
            }
        
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
