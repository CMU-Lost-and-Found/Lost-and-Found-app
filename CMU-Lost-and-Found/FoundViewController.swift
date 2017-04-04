//
//  FoundViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/1/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FoundViewController: UIViewController {

    
    @IBOutlet weak var post: UIButton!
    
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    var ref = FIRDatabase.database().reference()
    var userID = String()
    var firstNameObject = String()
    var lastNameObject = String()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.showAnimate()
        ref = ref.child("Found").childByAutoId()
        
        userID = UserDefaults.standard.object(forKey: "id") as! String
        
        firstNameObject = UserDefaults.standard.object(forKey: "first_name") as! String
        
        lastNameObject = UserDefaults.standard.object(forKey: "last_name") as! String
        
        username = "\(firstNameObject) \(lastNameObject)"
        namelabel.text = username
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        
        self.removeAnimate()
        
      
    }
    
    
    
    @IBAction func clickPost(_ sender: Any) {
        
        
        let posted = ["UserID": userID,
                      "Username": username,
                      "Text": descriptionText.text,
                      "Topic": topic.text as Any] as [String : Any]
        ref.updateChildValues(posted)
        self.removeAnimate()
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
