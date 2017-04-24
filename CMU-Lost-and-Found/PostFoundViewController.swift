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

class PostFoundViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    var postarray = [Post]()

    var ref = FIRDatabase.database().reference().child("Found")
    var refhandle : UInt!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPost = [Post]()
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredPost = postarray.filter{
            posttopic in return (posttopic.topic!.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // code here
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        loadData()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""{
            return self.filteredPost.count
        }
        print("post count = \(postarray.count)")
        return self.postarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostTableViewCell
        
        
        let post: Post
        
        if searchController.isActive && searchController.searchBar.text != ""{
            post = filteredPost[indexPath.row]
        }
        else {
            post = postarray[indexPath.row]
        }
        print(" post = \(postarray[indexPath.row])")
        cell.namelabel.text = post.username
        cell.postLabel.text = post.posttxt
        cell.topic.text = post.topic
        cell.time.text = post.time
        cell.statusImg.isHidden = post.postStatus!
        let profilePicObject = post.profilePic
        if let url = NSURL(string: profilePicObject!) {
            if let data = NSData(contentsOf: url as URL){
                cell.profile.image = UIImage(data: data as Data)
            }
        }
        let img = post.image
        if let url = NSURL(string: img!) {
            if let data = NSData(contentsOf: url as URL){
                cell.postPic.image = UIImage(data: data as Data)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        myVC.passDes = postarray[indexPath.row].posttxt!
        myVC.passTopic = postarray[indexPath.row].topic!
        myVC.passname = postarray[indexPath.row].username!
        myVC.passtime = postarray[indexPath.row].time!
        myVC.postID = postarray[indexPath.row].postID!
        myVC.passbartitle = "Found"
        myVC.passImage = postarray[indexPath.row].image!
        let profilePicObject = postarray[indexPath.row].profilePic
        myVC.passProPic = profilePicObject!
        myVC.passUserID=postarray[indexPath.row].userID!
        myVC.postStatus = postarray[indexPath.row].postStatus!
        
        self.present(myVC, animated: true, completion: nil)
        postarray.removeAll()
    }
    
    
    
    
    @IBAction func clickPost(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoundViewController") as! FoundViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        postarray.removeAll()
        
        
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
        
        self.postarray.removeAll()
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
                    post.userID = postElement["UserID"] as? String
                    post.postStatus = postElement["status"] as? Bool
                    self.postarray.append(post)
                }
                print("post = \(self.postarray)")
                
                self.postarray.sort(by: { $0.time! > $1.time! })
                
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
extension PostFoundViewController:UISearchResultsUpdating{
    func updateSearchResultForSerchController(searchController: UISearchController){
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

