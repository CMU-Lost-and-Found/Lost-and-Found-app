//
//  LostHisCell.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit

class LostHisCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
