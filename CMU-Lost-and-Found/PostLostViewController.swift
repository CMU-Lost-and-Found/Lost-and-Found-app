//
//  PostLostViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/3/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostLostViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var post = [Post]()
    
    var ref = FIRDatabase.database().reference().child("Lost")
    var refhandle : UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        ref.observe(.value, with: { (snapshot:FIRDataSnapshot!) in
            
            
            print(snapshot.childrenCount)
            print(snapshot)
        })
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lostcell", for: indexPath) as! LostTableViewCell
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        myVC.passDes = post[indexPath.row].posttxt!
        myVC.passTopic = post[indexPath.row].topic!
        myVC.name = post[indexPath.row].username!
        
        
        self.present(myVC, animated: true, completion: nil)
    }

    
    
    @IBAction func post(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    @IBAction func changView(_ sender: Any) {
        
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
        ref.queryOrdered(byChild: "Lost").observe(.value, with: { snapshot in
            
            //if !snapshot.exists() { return }
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                
                for(_,postElement) in postDict{
                    
                    print(postElement)
                    let post = Post()
                    post.username = postElement["Username"] as? String
                    post.posttxt = postElement["Text"] as? String
                    post.topic = postElement["Topic"] as? String
                    post.profilePic = postElement["LinkPicture"] as? String
                    post.time = postElement["Time"] as? String
                    self.post.append(post)
                }
                print("post = \(self.post)")
                
                self.post.sort(by: { $0.time! < $1.time! })
                
                self.tableView.reloadData()
            }
            
            
            
        })
    }

}
