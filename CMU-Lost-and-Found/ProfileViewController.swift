//
//  ProfileViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    let userRef = FIRDatabase.database().reference().child("User")
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var descrition: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var LinkFBButton: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    let userID = UserDefaults.standard.object(forKey: "id") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(userID: userID)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderWidth = 3.0
        self.profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.contentMode = .scaleToFill
        
        let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
        if let url = NSURL(string: profilePicObject as! String) {
            if let data = NSData(contentsOf: url as URL){
                profilePic.image = UIImage(data: data as Data)
            }
        }

        
        
        // Do any additional setup after loading the view.

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        //let idObject = UserDefaults.standard.object(forKey: "id")
        let firstNameObject = UserDefaults.standard.object(forKey: "first_name")
        
        let lastNameObject = UserDefaults.standard.object(forKey: "last_name")
        
        let username = "\(firstNameObject!) \(lastNameObject!)"
        
        let linkObject = UserDefaults.standard.object(forKey: "link")
        LinkFBButton.setTitle("\(linkObject!)", for: .normal)
        
        nameLabel.text = username
    }
    
    @IBAction func didTapFBLink(_ sender: Any) {
        let linkObject = UserDefaults.standard.object(forKey: "link")
        if let url = NSURL(string: "\(String(describing: linkObject))"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editTapped(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditVC") as! EditVC
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    

    func loadData(userID : String) {
        userRef.child(userID).observe(.value, with: { (snapshot) in
            print("snapshot : \(snapshot)")
            if let userDic = snapshot.value as? [String : AnyObject]{
                
                self.contact.text =  userDic["Contact"] as? String
                self.descrition.text = userDic["Description"] as? String
            }

        })
    }
    

}
