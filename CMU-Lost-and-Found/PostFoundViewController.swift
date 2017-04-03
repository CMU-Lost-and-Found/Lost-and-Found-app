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

    var ref = FIRDatabase.database().reference().child("Lost")
    var refhandle : UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! PostTableViewCell
        
        print(" post = \(post[indexPath.row])")
        cell.namelabel.text = post[indexPath.row].username
        cell.postLabel.text = post[indexPath.row].posttxt
        
        return cell
    }
    
    
    
    
    
    @IBAction func clickPost(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    
    @IBAction func changedPage(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "PostFoundViewController") as! PostFoundViewController
            //let newFrontViewController = UINavigationController.init(rootViewController:desController)
            
            self.present(desController, animated: true, completion: nil)
            
        case 1:
            
            let mainStory: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let desController = mainStory.instantiateViewController(withIdentifier: "PostLostViewController") as! PostLostViewController
            //let newFrontViewController = UINavigationController.init(rootViewController:desController)
            
            self.present(desController, animated: true, completion: nil)
            
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
                    self.post.append(post)
                }
                print("post = \(self.post)")
                
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
