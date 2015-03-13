//
//  ViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/9/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var alreadyRegistered: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpToggleButton: UIButton!
    @IBOutlet weak var myUsername: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var signupActive = true
    
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        if signupActive == true {
            signupActive = false
            signUpLabel.text = "Use the form below to log in"
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not Registered?"
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        } else {
            signupActive = true
            signUpLabel.text = "Use the form below to sign up"
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already Registered?"
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func doSignUp(sender: AnyObject) {
        var error = ""
        if myUsername.text == "" || myPassword.text == "" {
            error = "Please enter a username and password"
        }
        
        if error != "" {
            displayAlert("Error in Form", error: error)
        } else {
            //Attempt to sign up the user using Parse.
            var user = PFUser()
            user.username = myUsername.text
            user.password = myPassword.text
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive {
                user.signUpInBackgroundWithBlock({ (success: Bool!, signupError: NSError!) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if signupError == nil {
                        //Hooray! Let them user the app now.
                        self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                        NSLog("Success!")
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Please try again later."
                        }
                        self.displayAlert("Could Not Sign Up", error: error)
                    }
                })
            } else {
                PFUser.logInWithUsernameInBackground(myUsername.text, password: myPassword.text, block: { (user: PFUser!, loginError: NSError!) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if (loginError == nil) {
                        //Succesful login.
                        self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                        NSLog("Success!")
                    } else {
                        if let errorString = loginError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Please try again later."
                        }
                        self.displayAlert("Could Not Sign Up", error: error)
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            NSLog("\(PFUser.currentUser().username)")
            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }


}

