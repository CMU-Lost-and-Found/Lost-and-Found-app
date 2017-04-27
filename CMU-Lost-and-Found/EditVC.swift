 //
//  EditVC.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 4/25/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController {

    @IBOutlet weak var contactText: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    let userID = UserDefaults.standard.object(forKey: "id")
    var userRef = FIRDatabase.database().reference().child("User")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    @IBAction func doneTapped(_ sender: Any) {
        updateData(id: userID as! String)
        ProfileViewController().loadView()
        removeAnimate()
    }

    func updateData(id : String) {
        userRef = userRef.child(id)
        let posted = ["Contact": contactText.text!,
                      "Description": descriptionField.text!] as [String : Any]
                      
        userRef.updateChildValues(posted)
    }
    @IBAction func backTapped(_ sender: Any) {
        removeAnimate()
    }

}
