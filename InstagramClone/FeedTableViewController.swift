//
//  FeedTableViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/13/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Download info from Parse.
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if let users = objects {
                self.messages.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                
                for object in users {
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username!
                    }
                }//end for loop
            } //end if
            
            let getFollowedUsersQuery = PFQuery(className: "followers")
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
            getFollowedUsersQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if let objects = objects {
                    for object in objects {
                        let followedUser = object["following"] as! String
                        let query = PFQuery(className: "Post")
                        query.whereKey("userId", equalTo: followedUser)
                        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                            if let objects = objects {
                                for object in objects {
                                    self.messages.append(object["message"] as! String)
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    self.usernames.append(self.users[object["userId"] as! String]!)
                                    self.tableView.reloadData()
                                }
                            }
                        }) //end follower query
                    } //end for loop
                } //end if
            }) //end followers query
            
        }) //end users query
    } //end viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    } //end numberOfSectionsInTableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
    } //end numberOfRowsInSection

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellTableViewCell
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if let downloadedImage = UIImage(data: data!) {
                cell.myImageView.image = downloadedImage
            }
        } //end getDataInBackgroundWithBlock
        cell.myUsernameLabel.text = usernames[indexPath.row]
        cell.myTitleLabel.text = messages[indexPath.row]
        return cell
    } //end cellForRowAtIndexPath

} //end FeedTableViewController
