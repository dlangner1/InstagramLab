//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dustin Langner on 1/27/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!

    var instaPosts: [NSDictionary]?
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollAcvtivityView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.fetchInstagramData()
        self.loadingImageImage()
        self.controlRefresh()

    }
    
    
    // controlls the pull down refresh option
    func controlRefresh() {
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
    
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
                            
                            // Update flag
                            self.isMoreDataLoading = false
                            
                            // Stop the loading indicator
                            self.loadingMoreView!.stopAnimating()

                    }
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
        });
        task.resume()
        
        
    }
    
    func loadingImageImage() {
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollAcvtivityView.defaultHeight)
        loadingMoreView = InfiniteScrollAcvtivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollAcvtivityView.defaultHeight;
        tableView.contentInset = insets
    
    
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            isMoreDataLoading = true
        }
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
            isMoreDataLoading = true
            
            // Update position of loadingMoreView, and start loading indicator
            let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollAcvtivityView.defaultHeight)
            loadingMoreView?.frame = frame
            loadingMoreView!.startAnimating()
            
            fetchInstagramData()
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let posts = instaPosts![indexPath!.row]
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        vc.instagramPosts = posts
        
    }

}


