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
    
    @IBOutlet weak var tableView: UITableView!
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
    var passUserID = String()
    var postStatus = Bool()

    let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
    let firstNameObject = UserDefaults.standard.object(forKey: "first_name") as! String
    
    let lastNameObject = UserDefaults.standard.object(forKey: "last_name") as! String
    let userID = UserDefaults.standard.object(forKey: "id") as! String
    
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
            if userID == passUserID && postStatus{
                cell.completeBtn.isHidden = false
            }
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
            if postStatus {
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
            return UITableViewCell()
            
            
        }
        
    }
    
    @IBAction func postTapped(_ sender: Any) {
        loadData()
        tableView.reloadData()
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

    
    
    func loadData(){
        
        let ref = FIRDatabase.database().reference().child(passbartitle).child(postID).child("Reply")
        ref.observe(.value, with: { snapshot in
            
            //if !snapshot.exists() { return }
            print("snap = \(snapshot)")
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                self.reply.removeAll()
                for(postID,postElement) in postDict{
                    let reply = Reply()
                    reply.postID = postID
                    reply.username = postElement["Username"] as? String
                    reply.posttxt = postElement["Text"] as? String
                    reply.profilePic = postElement["LinkPicture"] as? String
                    reply.time = postElement["Time"] as? String
                    self.reply.append(reply)
                    print("Reply : \(reply)")
                }
                self.reply.sort(by: { $0.time! < $1.time! })
            }
            
            
            
        })
    }

    @IBAction func completeTapped(_ sender: Any) {
        print("Tapp Complete")
        let ref = FIRDatabase.database().reference().child(passbartitle).child(postID)
        let alert = UIAlertController(title: "แจ้งปิดการประกาศ", message: "กรุณากดปุ่มยืนยันเพื่อทำการปิดโพส", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "ยืนยัน", style: .default, handler: { action in
                print("default")
                let status = ["status" : false]
                ref.updateChildValues(status)
                PostFoundViewController().removeData()
                PostLostViewController().removeData()
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    

}
