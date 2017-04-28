//
//  PostViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Thitiwat on 3/28/2560 BE.
//  Copyright © 2560 Watchanan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var post: UIBarButtonItem!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    var imagePicker : UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    var downloadUrl : String?
    
    
    
    var ref = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    var userID = String()
    var firstNameObject = String()
    var lastNameObject = String()
    var username = String()
    let profilePicObject = UserDefaults.standard.object(forKey: "profilepic")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        profilepic.layer.cornerRadius = self.profilepic.frame.height/2
        profilepic.clipsToBounds = true
        profilepic.layer.borderWidth = 3.0
        profilepic.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        self.showAnimate()
        
        ref = ref.child("Lost").childByAutoId()
        
        userID = UserDefaults.standard.object(forKey: "id") as! String
        
        firstNameObject = UserDefaults.standard.object(forKey: "first_name") as! String
        
        lastNameObject = UserDefaults.standard.object(forKey: "last_name") as! String
        
        username = "\(firstNameObject) \(lastNameObject)"
        namelabel.text = username
        
        
        if let url = NSURL(string: profilePicObject as! String) {
            if let data = NSData(contentsOf: url as URL){
                profilepic.image = UIImage(data: data as Data)
            }
        }

        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topic.resignFirstResponder()
        descriptionText.resignFirstResponder()
        
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickPost(_ sender: Any) {
            if descriptionText.text.characters.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "กรุณาใส่ข้อความ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if  (topic.text?.characters.count)! >= 20 && (topic.text?.characters.count)! <= 150{
            
            let alert = UIAlertController(title: "Topic-Alert", message: "Topic ต้องมีความย่าวระหว่าง 20 - 150 อักษร  ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'|'HH:mm:ss"
            formatter.timeZone = TimeZone(secondsFromGMT: -7)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            let posted = ["Time": formatter.string(from: date),
                          "UserID": userID,
                          "Username": username,
                          "Text": descriptionText.text,
                          "UserImage": profilePicObject!,
                          "Topic": topic.text!,
                          "ImageUrl" : downloadUrl!,
                          "status" : true] as [String : Any]
            ref.updateChildValues(posted)
            self.removeAnimate()
        }
    }

    @IBAction func back(_ sender: Any) {
        
        self.removeAnimate()
       
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
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            print("ImagePicker : Selected")
            let imgUid = NSUUID().uuidString
            var data = NSData()
            data = UIImageJPEGRepresentation(imageAdd.image!, 0.8)! as NSData
            // set upload path
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.child(imgUid).put(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //store downloadURL
                    self.downloadUrl = metaData!.downloadURL()!.absoluteString
                    print("Successfully to upload : \(self.downloadUrl!)")
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
