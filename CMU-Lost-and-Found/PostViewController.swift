//
//  PostViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostViewController: UIViewController {
    @IBOutlet weak var postTXT: UITextField!

    @IBOutlet weak var post: UIBarButtonItem!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    
    
    var ref = FIRDatabase.database().reference()
    var userID = String()
    var firstNameObject = String()
    var lastNameObject = String()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        namelabel.text = UserDefaults.standard.object(forKey: "first_name") as! String?
        
        ref = ref.child("Post").childByAutoId()
        
        userID = UserDefaults.standard.object(forKey: "id") as! String
        
        firstNameObject = UserDefaults.standard.object(forKey: "first_name") as! String
        
        lastNameObject = UserDefaults.standard.object(forKey: "last_name") as! String
        
        username = "\(firstNameObject) \(lastNameObject)"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickPost(_ sender: Any) {
        
        
        let posted = ["UserID": userID,
                      "Username": username,
                      "Text": postTXT.text as Any] as [String : Any]
        ref.updateChildValues(posted)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
