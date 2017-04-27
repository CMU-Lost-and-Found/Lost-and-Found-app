//
//  MenuViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userLogin: UILabel!
    
    
    var menulist = ["PostFeed","Profile","Notification","History","Setting","Logout"]
    var imagelist = ["Home.png", "usericon.png", "notification.png", "history.png", "setting.png","Logout.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.layer.borderWidth = 3.0
        profilePic.layer.borderColor = UIColor.white.cgColor

        // Do any additional setup after loading the view.
        let firstName = UserDefaults.standard.object(forKey: "first_name")
        let lastName = UserDefaults.standard.object(forKey: "last_name")
        userLogin.text = "\(firstName!) \(lastName!)"
        let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
        if let url = NSURL(string: profilePicObject as! String) {
            if let data = NSData(contentsOf: url as URL){
                profilePic.image = UIImage(data: data as Data)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menulist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        cell.menuImage.image = UIImage(named: imagelist[indexPath.row])
        cell.menuLable.text = menulist[indexPath.row]
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController: SWRevealViewController = self.revealViewController()
        
        let cell : MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if cell.menuLable.text == "Profile"
        {
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            revealViewController.pushFrontViewController(desController, animated: true)
        }
        
        if cell.menuLable.text == "PostFeed"
        {
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "PostFoundViewController") as! PostFoundViewController
            revealViewController.pushFrontViewController(desController, animated: true)
        }
        
        if cell.menuLable.text == "Logout" {
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            present(desController, animated: true, completion: nil)
            UserDefaults.standard.removeObject(forKey: "id")
            
        }
        if cell.menuLable.text == "History" {
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "FoundHisVC") as! FoundHisVC
            revealViewController.pushFrontViewController(desController, animated: true)

            
        }
        
    }
}
