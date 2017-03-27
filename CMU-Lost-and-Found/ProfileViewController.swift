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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //let idObject = UserDefaults.standard.object(forKey: "id")

        let firstNameObject = UserDefaults.standard.object(forKey: "first_name")
        
        let lastNameObject = UserDefaults.standard.object(forKey: "last_name")
        
        let username = "\(firstNameObject!) \(lastNameObject!)"
        
        nameLabel.text = username
        
        let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
        print(profilePicObject! as Any)
        let url = "\(profilePicObject!)"
        
        print(url)
        
            if let image = getProfPic(fid: "asd") {
                profilePic?.image = image

            }
        
        
    }
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            let imgURLString = "https://qph.ec.quoracdn.net/main-thumb-t-1800-200-lOn8kKfhqfcTcKdt2GwaLfGnC0jEjHmV.jpeg" //type=normal
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOf: imgURL! as URL)
            let image = UIImage(data: imageData! as Data)
            return image
        }
        return nil
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
