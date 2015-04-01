//
//  SignUpViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/1/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBAction func signup(sender: AnyObject) {
        println("username: " + username.text)
        println("password: " + password.text)
        println("confirmpassword: " + confirmPassword.text)
        println("phone: " + phoneNumber.text)
        
    }
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
