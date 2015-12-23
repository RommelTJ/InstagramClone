//
//  UserTableViewController.swift
//  InstagramClone
//
//  Created by Rommel Rico on 3/11/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    var usernames = [String]()
    var userids = [String]()
    var isFollowing = [String: Bool]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh!")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        refresh()
    }

    func refresh() {
        updateUsers()
    }
    
    func updateUsers() {
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if let users = objects {
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                for object in users {
                    if let user = object as? PFUser {
                        if user.objectId! != PFUser.currentUser()?.objectId {
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            let query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                if let objects = objects {
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                if self.isFollowing.count == self.usernames.count {
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                }
                            })
                        } //end if
                    } //end if
                } //end for loop
            } //end if
        }) //end query
    } //end updateUsers
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return usernames.count
    } //end numberOfRowsInSection

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = usernames[indexPath.row]
        let followedObjectId = userids[indexPath.row]
        if isFollowing[followedObjectId] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    } //end cellForRowAtIndexPath

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let followedObjectId = userids[indexPath.row]
        
        if isFollowing[followedObjectId] == false {
            isFollowing[followedObjectId] = true
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            let following = PFObject(className: "followers")
            following["following"] = userids[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            following.saveInBackground()
        } else {
            isFollowing[followedObjectId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            let query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            query.whereKey("following", equalTo: userids[indexPath.row])
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
        } //end else
    } //end didSelectRowAtIndexPath

} //end UserTableViewController
