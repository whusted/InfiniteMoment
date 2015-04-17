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
    
    override func viewDidLoad() {
        println("In Text Creation")
        super.viewDidLoad()
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
            println(parameters)
            // TODO: pass parameters to recipients view (friends list)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toRecipientsList") {
            var recipients = segue.destinationViewController as! RecipientsListViewController;
            recipients.parameters = parameters
        }
    }
    
}

