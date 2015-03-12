//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/12/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    var photoSelected: Bool =  false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func doChooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        //TODO: Add a pop-up to allow user to choose between Camera and PhotoLibrary
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image selected!")
        self.dismissViewControllerAnimated(true, completion: nil)
        //myImageView.image = image
        myImageView.image = imageWithImage(image, size: CGSize(width: 150, height: 150))
        photoSelected = true
    }
    
    @IBAction func doPostImage(sender: AnyObject) {
        var error = ""
        if photoSelected == false {
            error = "Please select an image to post!"
        } else if (myTextField.text == "") {
            error = "Please enter a message to post!"
        }
        
        if (error != "") {
            displayAlert("Error with Image", error: error)
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            
            var post = PFObject(className: "Post")
            post["Title"] = myTextField.text
            post["username"] = PFUser.currentUser().username
            post.saveInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                if error == nil {
                    let imageData = UIImagePNGRepresentation(self.myImageView.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    post.saveInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        if error == nil {
                            self.displayAlert("Success!", error: "Your image posted successfully!")
                            self.photoSelected = false
                            self.myImageView.image = UIImage(named: "Blank_woman_placeholder.svg")
                            self.myTextField.text = ""
                        } else {
                            self.displayAlert("Could not post image!", error: "Please try again later")
                        }
                    })
                } else {
                    self.displayAlert("Could not post image", error: "Please try again later")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            })
        }
    }
    
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imageWithImage(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSelected = false
        myImageView.image = UIImage(named: "Blank_woman_placeholder.svg")
        myTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
