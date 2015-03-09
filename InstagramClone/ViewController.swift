//
//  ViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/9/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Parse.setApplicationId("REDACTED", clientKey: "REDACTED")
        
        /*
        var score = PFObject(className: "score")
        score.setObject("Rommel", forKey: "name")
        score.setObject(23, forKey: "number")
        score.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success) {
                NSLog("We were successful! ObjectId = \(score.objectId)")
            } else {
                NSLog("ERROR: \(error)")
            }
        }
        */
        
        //Retrieving data from Parse
        var query = PFQuery(className: "score")
        query.getObjectInBackgroundWithId("aeSjso2Ysm", block: { (score, error) -> Void in
            if(error == nil) {
                //var value = score.objectForKey("number") as NSNumber
                //NSLog("The score object is: \(value)")
                
                //Another way
                //var value = score["name"]
                //NSLog("The score object is: \(value)")
                
                //Updating the score.
                score["name"] = "Rommel"
                score["number"] = 137
                score.save()
            } else {
                NSLog("ERROR: \(error)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

