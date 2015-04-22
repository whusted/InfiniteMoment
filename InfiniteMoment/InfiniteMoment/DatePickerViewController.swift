//
//  DatePickerViewController.swift
//  InfiniteMoment
//
//  Created by Willy Husted on 4/21/15.
//  Copyright (c) 2015 Infinite Moment LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Security
import Lockbox

class DatePickerViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var parameters = Dictionary<String, AnyObject>()
    let token = Lockbox.stringForKey("authToken")
    
    override func viewDidLoad() {
        println(token)
        println(parameters)
        parameters["Authorization"] = self.token
        super.viewDidLoad()
        datePickerChanged(datePicker)
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        // TODO: set minimum date and time to 'now'
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        dateLabel.text = strDate
    }
    
    func formatDate(datePicker:UIDatePicker) -> String {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let iso8601String = dateFormatter.stringFromDate(datePicker.date)
        return iso8601String
    }
    
    @IBAction func sendMoment(sender: AnyObject) {
        // Reformat to ISO 8601 date before sending
        deliverMoment()
    }
    
    func deliverMoment() {
        parameters["recipients"] = ["test3"]
        parameters["deliveryDate"] = formatDate(datePicker)
        println("params: \(parameters)")
        Alamofire.request(.POST, "http://localhost:7777/moments", parameters: parameters, encoding: .JSON)
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
        }

    }

}
