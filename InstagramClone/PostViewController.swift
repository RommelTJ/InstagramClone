//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/12/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func doChooseImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        myImageView.image = imageWithImage(image, size: CGSize(width: 150, height: 150))
    }
    
    @IBAction func doPostImage(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Post")
        post["message"] = myTextField.text
        post["userId"] = PFUser.currentUser()!.objectId!
        let imageData = UIImagePNGRepresentation(myImageView.image!)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        post["imageFile"] = imageFile
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if error == nil {
                //Successfully posted the image.
                self.displayAlert("Image posted!", error: "Your image has been posted successfully!")
                self.myImageView.image = UIImage(named: "Blank_woman_placeholder")
                self.myTextField.text = ""
            } else {
                self.displayAlert("Could not post image", error: "Please try again later")
            }
        }//end saveInBackgroundWithBlock
    } //end doPostImage
    
    func displayAlert(title:String, error:String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    } //end displayAlert
    
    func imageWithImage(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    } //end imageWithImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
    } //end viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
