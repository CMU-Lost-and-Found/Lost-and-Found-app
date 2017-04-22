//
//  HeaderTableViewCell.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/6/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var des: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
