//
//  ViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/9/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func doCreateAlert(sender: AnyObject) {
        var alert = UIAlertController(title: "Hey There!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func doRestoreApp(sender: AnyObject) {
        activityIndicator.stopAnimating()
//        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func doPauseApp(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        myImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    @IBAction func doPickImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        myImageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
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
        */
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

