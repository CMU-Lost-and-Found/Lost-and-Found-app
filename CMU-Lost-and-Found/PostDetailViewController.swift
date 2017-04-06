//
//  PostDetailViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/6/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navBarPostDetail: UINavigationBar!
    var passTopic = String()
    var passDes = String()
    var passname = String()
    var passtime = String()
    var passbartitle = String()
    var passProPic	= String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarPostDetail.topItem?.title = passbartitle

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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! HeaderTableViewCell
        
        cell1.topic.text = passTopic
        cell1.des.text = passDes
        cell1.name.text = passname
        cell1.time.text = passtime
        if let url = NSURL(string: passProPic) {
            if let data = NSData(contentsOf: url as URL){
                cell1.profilePic.image = UIImage(data: data as Data)
            }
        }
        
        return cell1
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
