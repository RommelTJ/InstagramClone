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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

