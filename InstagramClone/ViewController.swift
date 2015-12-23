//
//  ViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/9/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var signupActive = true
    @IBOutlet weak var myUsername: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyRegistered: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        if signupActive == true {
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        } else {
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already Registered?"
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            signupActive = true
        }
    } //end toggleSignUp
    
    @IBAction func doSignUp(sender: AnyObject) {
        if myUsername.text == "" || myPassword.text == "" {
            displayAlert("Error in form", error: "Please enter a username and password")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signupActive == true {
                //Attempt to sign up the user using Parse.
                let user = PFUser()
                user.username = myUsername.text
                user.password = myPassword.text
                
                user.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if error == nil {
                        //Sign up successful
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        if let errorString = error?.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Could Not Sign Up", error: errorMessage)
                    }
                })
            } else {
                PFUser.logInWithUsernameInBackground(myUsername.text!, password: myPassword.text!, block: { (user: PFUser?, error: NSError?) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if user != nil {
                        //Logged in.
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Could Not Log In", error: errorMessage)
                    }
                })
            } //end else block
        } //end else block
    } //end doSignUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
}

