//
//  InstaCell.swift
//  Instagram
//
//  Created by Dustin Langner on 1/27/16.
//  Copyright © 2016 Dustin Langner. All rights reserved.
//

import UIKit

class InstaCell: UITableViewCell {

    @IBOutlet weak var instaImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
