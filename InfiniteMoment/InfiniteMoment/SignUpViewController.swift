//
//  SignUpViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/1/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire

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
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
            }
        
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
