//
//  PostFoundViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class PostFoundViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var post = [Post]()

    var ref = FIRDatabase.database().reference().child("Found")
    var refhandle : UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        loadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("post count = \(post.count)")
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostTableViewCell
        
        print(" post = \(post[indexPath.row])")
        cell.namelabel.text = post[indexPath.row].username
        cell.postLabel.text = post[indexPath.row].posttxt
        cell.topic.text = post[indexPath.row].topic
        cell.time.text = post[indexPath.row].time
        let profilePicObject = post[indexPath.row].profilePic
        if let url = NSURL(string: profilePicObject!) {
            if let data = NSData(contentsOf: url as URL){
                cell.profile.image = UIImage(data: data as Data)
            }
        }
        let img = post[indexPath.row].image
        if let url = NSURL(string: img!) {
            if let data = NSData(contentsOf: url as URL){
                cell.postPic.image = UIImage(data: data as Data)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        myVC.passDes = post[indexPath.row].posttxt!
        myVC.passTopic = post[indexPath.row].topic!
        myVC.passname = post[indexPath.row].username!
        myVC.passtime = post[indexPath.row].time!
        myVC.postID = post[indexPath.row].postID!
        myVC.passbartitle = "Found"
        myVC.passImage = post[indexPath.row].image!
        let profilePicObject = post[indexPath.row].profilePic
        myVC.passProPic = profilePicObject!
        
        self.present(myVC, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func clickPost(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoundViewController") as! FoundViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        post.removeAll()
        
        
    }
    
    @IBAction func changedPage(_ sender: Any) {
        
        let revealViewController: SWRevealViewController = self.revealViewController()
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier:"PostFoundViewController") as! PostFoundViewController
            //let newFrontViewController = UINavigationController.init(rootViewController:desController)
            
            revealViewController.pushFrontViewController(desController, animated: true)
            
        case 1:
            
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier:"PostLostViewController") as! PostLostViewController
            //let newFrontViewController = UINavigationController.init(rootViewController:desController)
            
            revealViewController.pushFrontViewController(desController, animated: true)
            
        default:
            break
        }
        
        
    }
    
    
    func loadData(){
        
        self.post.removeAll()
        ref.queryOrdered(byChild: "Found").observe(.value, with: { snapshot in
            
            //if !snapshot.exists() { return }
            
            if let postDict = snapshot.value as? [String : AnyObject]{

                for(postID,postElement) in postDict{
                    let post = Post()
                    post.postID = postID
                    post.username = postElement["Username"] as? String
                    post.posttxt = postElement["Text"] as? String
                    post.topic = postElement["Topic"] as? String
                    post.profilePic = postElement["UserImage"] as? String
                    post.time = postElement["Time"] as? String
                    post.image = postElement["ImageUrl"] as? String
                    self.post.append(post)
                }
                print("post = \(self.post)")
                
                self.post.sort(by: { $0.time! > $1.time! })
                
                self.tableView.reloadData()
            }
            
            
            
        })
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
