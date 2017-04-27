//
//  PostReplyTableViewCell.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/15/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var replyText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var postID : String?
    var postType : String?
    
    var userID = UserDefaults.standard.object(forKey: "id")
    var profileImageObj = UserDefaults.standard.object(forKey: "profilepic")
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func postClick(_ sender: Any) {
        let ref = FIRDatabase.database().reference().child(postType!).child(postID!).child("Reply").childByAutoId()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'|'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: -7)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let posted = ["Time": formatter.string(from: date),
                      "UserID" : userID!,
                      "Username": nameLabel.text!,
                      "Text": replyText.text,
                      "LinkPicture": profileImageObj! as Any] as [String : Any]
        ref.updateChildValues(posted)
        replyText.text = ""
    }
}
