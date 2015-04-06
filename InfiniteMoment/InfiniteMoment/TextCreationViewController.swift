//
//  TextCreationViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/3/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lockbox

class TextCreationViewController: UIViewController {
    
    let token = Lockbox.stringForKey("authToken")
    
    @IBOutlet weak var textBox: UITextField!
    
    override func viewDidLoad() {
        println("In Text Creation")
        let token = Lockbox.stringForKey("authToken")
        super.viewDidLoad()
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        
        let parameters = [
            "Authorization": token,
            "conent": textBox.text,
            "recipients": [],
            "deliveryDate": nil
        ]
        
        if textBox.text.isEmpty {
            var alert = UIAlertController(title: "Oops!", message: "No one wants a blank Moment!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
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
    
}

