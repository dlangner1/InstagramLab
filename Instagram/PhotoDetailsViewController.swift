//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Dustin Langner on 2/3/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    
    var instagramPosts: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imagePath = instagramPosts.valueForKeyPath("images.low_resolution.url") as? String {
            
            let imageUrl = NSURL(string: imagePath)
            
            posterView.setImageWithURL(imageUrl!)
        }

        // Do any additional setup after loading the view.
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
