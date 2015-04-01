//
//  LoginViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 3/31/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(sender: AnyObject) {
        let username = usernameField.text
        let password = passwordField.text
        
        println("username: " + username)
        println("password: " + password)
    }
}
