//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dustin Langner on 1/27/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var instaPosts: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.fetchInstagramData()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInstagramData() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.instaPosts = responseDictionary["data"] as? [NSDictionary]
                    }
                }
                self.tableView.reloadData()
                
        });
        task.resume()
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let instaPosts = instaPosts {
            return instaPosts.count
        } else {
            return 0
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
        let igPost = instaPosts![indexPath.row]
        
        if let imagePath = igPost.valueForKeyPath("images.low_resolution.url") as? String {
            
            let imageUrl = NSURL(string: imagePath)
            
            cell.instaImageView.setImageWithURL(imageUrl!)
        }
        
        if let username = igPost.valueForKeyPath("user.username") as? String {
            cell.usernameLabel.text =  username
        } else  {
            cell.usernameLabel.text = "0"
        }
            
        if let profilePicture = igPost.valueForKeyPath("user.profile_picture") as? String {
            let profilePictureImageURL = NSURL(string: profilePicture)
            cell.profilePictureImageView.setImageWithURL(profilePictureImageURL!)
            cell.profilePictureImageView.layer.cornerRadius = 15
            cell.profilePictureImageView.clipsToBounds = true

        }
        
        return cell
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

