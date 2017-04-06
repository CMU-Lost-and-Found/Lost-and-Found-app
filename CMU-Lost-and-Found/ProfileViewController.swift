//
//  ProfileViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var LinkFBButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderWidth = 3.0
        self.profilePic.layer.borderColor = UIColor.blue.cgColor
        profilePic.contentMode = .scaleToFill
        
        let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
        if let url = NSURL(string: profilePicObject as! String) {
            if let data = NSData(contentsOf: url as URL){
                profilePic.image = UIImage(data: data as Data)
            }
        }

        
        
        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
