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
    
    @IBOutlet weak var textBox: UITextField!
    var parameters = [String: String]()
    var friends = Array<JSON>()
    
    override func viewDidLoad() {
        getFriends("begin", completion: { (result) -> Void in
            println("Friends: \(self.friends)")
        })
        println("In Text Creation")
        super.viewDidLoad()
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
    
        
    
    @IBAction func nextButton(sender: AnyObject) {
        if textBox.text.isEmpty {
            var alert = UIAlertController(title: "Oops!", message: "No one wants a blank Moment!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.parameters = [
                "content": textBox.text
            ]
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toRecipientsList") {
            var recipients = segue.destinationViewController as! RecipientsListViewController;
            recipients.parameters = parameters
            recipients.friends = friends
        }
    }
    
}

