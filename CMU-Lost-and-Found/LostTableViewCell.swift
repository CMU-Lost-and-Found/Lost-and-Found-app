//
//  LostTableViewCell.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/4/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit

class LostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var postPic: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var topic: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
