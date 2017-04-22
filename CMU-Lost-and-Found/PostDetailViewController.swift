//
//  PostDetailViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/6/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var navBarPostDetail: UINavigationBar!
    var postID = String()
    var passTopic = String()
    var passDes = String()
    var passname = String()
    var passtime = String()
    var passbartitle = String()
    var passProPic	= String()
    var reply = [Reply]()
    var passImage = String()

    let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
    let firstNameObject = UserDefaults.standard.object(forKey: "first_name") as! String
    
    let lastNameObject = UserDefaults.standard.object(forKey: "last_name") as! String
    
    var username :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = "\(firstNameObject) \(lastNameObject)"
        navBarPostDetail.topItem?.title = passbartitle
        print(postID)
        
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reply.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! HeaderTableViewCell
            cell.topic.text = passTopic
            cell.des.text = passDes
            cell.name.text = passname
            cell.time.text = passtime
            if let url = NSURL(string: passProPic) {
                if let data = NSData(contentsOf: url as URL){
                    cell.profilePic.image = UIImage(data: data as Data)
                    }
                }
            if let url = NSURL(string: passImage) {
                if let data = NSData(contentsOf: url as URL){
                    cell.postImage.image = UIImage(data: data as Data)
                }
            }
            return cell
        }
        else if indexPath.row > 0 && indexPath.row <= reply.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ReplyTableViewCell

            cell.nameLabel.text = reply[indexPath.row-1].username
            cell.replyText.text = reply[indexPath.row-1].posttxt
            if let url = NSURL(string: reply[indexPath.row-1].profilePic!) {
                if let data = NSData(contentsOf: url as URL){
                    cell.profileImage.image = UIImage(data: data as Data)
                }
            }
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! PostReplyTableViewCell
            cell.nameLabel.text = username
            if let url = NSURL(string: profilePicObject as! String) {
                if let data = NSData(contentsOf: url as URL){
                    cell.profileImage.image = UIImage(data: data as Data)
                }
            }
            cell.postID = postID
            cell.postType = passbartitle
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 0){
            return 300;
        }
        else if(indexPath.row > 0 && indexPath.row <= reply.count){
            return 100;
        }
        else{
            return 100; //a default size if the cell index path is anything other than the 1st or second row.
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadData(){
        
        let ref = FIRDatabase.database().reference().child(passbartitle).child(postID).child("Reply")
        ref.observe(.value, with: { snapshot in
            
            //if !snapshot.exists() { return }
            print("snap = \(snapshot)")
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                
                for(postID,postElement) in postDict{
                    let reply = Reply()
                    reply.postID = postID
                    reply.username = postElement["Username"] as? String
                    reply.posttxt = postElement["Text"] as? String
                    reply.profilePic = postElement["LinkPicture"] as? String
                    reply.time = postElement["Time"] as? String
                    self.reply.append(reply)
                }
                self.reply.sort(by: { $0.time! < $1.time! })
            }
            
            
            
        })
    }


}
