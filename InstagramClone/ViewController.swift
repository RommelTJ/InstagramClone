//
//  ViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/9/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var myUsername: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    
    @IBAction func doSignUp(sender: AnyObject) {
        var error = ""
        if myUsername.text == "" || myPassword.text == "" {
            error = "Please enter a username and password"
        }
        
        if error != "" {
            var alert = UIAlertController(title: "ERROR", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            //Attempt to sign up the user using Parse.
            var user = PFUser()
            user.username = myUsername.text
            user.password = myPassword.text
            user.signUpInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                if error == nil {
                    //Hooray! Let them user the app now.
                    NSLog("Success!")
                } else {
                    //let errorString = error.userInfo["error"]! as NSString
                    NSLog("\(error)")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

