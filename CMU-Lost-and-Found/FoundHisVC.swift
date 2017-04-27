//
//  FoundHisVC.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase


class FoundHisVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var postarray = [Post]()
    let userId = UserDefaults.standard.object(forKey: "id") as! String
    
    var ref = FIRDatabase.database().reference().child("Found")
    var refhandle : UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        loadData()
        definesPresentationContext = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundHis", for: indexPath) as! FoundHisToryCell
        
        let post: Post
        
        post = postarray[indexPath.row]
        
        cell.nameLabel.text = post.username
        cell.postLabel.text = post.posttxt
        cell.topic.text = post.topic
        cell.timeLabel.text = post.time
        
        let profilePicObject = post.profilePic
        if let url = NSURL(string: profilePicObject!) {
            if let data = NSData(contentsOf: url    as URL){
                cell.profilePic.image = UIImage(data: data as Data)
            }
        }
        let img = post.image
        if let url = NSURL(string: img!) {
            if let data = NSData(contentsOf: url as URL){
                cell.postImage.image = UIImage(data: data as Data)
            }
        }
        return cell
    }
    
    func loadData(){
        
        self.postarray.removeAll()
        ref.queryOrdered(byChild: "Found").observe(.value, with: { snapshot in
            
            //if !snapshot.exists() { return }
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                for(postID,postElement) in postDict{
                    let id = postElement["UserID"] as! String
                    if self.userId == id {
                        let post = Post()
                        post.postID = postID
                        post.username = postElement["Username"] as? String
                        post.posttxt = postElement["Text"] as? String
                        post.topic = postElement["Topic"] as? String
                        post.profilePic = postElement["UserImage"] as? String
                        post.time = postElement["Time"] as? String
                        post.image = postElement["ImageUrl"] as? String
                        post.userID = postElement["UserID"] as? String
                        post.postStatus = postElement["status"] as? Bool
                        self.postarray.append(post)
                    }
                }
                print("post = \(self.postarray)")
                self.postarray.sort(by: { $0.time! > $1.time! })
                self.tableView.reloadData()
            }
        })
    }
}

