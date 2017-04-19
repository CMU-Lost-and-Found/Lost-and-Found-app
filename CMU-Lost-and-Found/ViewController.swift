//
//  ViewController.swift
//  CMU-Lost-and-Found
//
//  Created by Tommie on 3/11/17.
//  Copyright © 2017 Watchanan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController , FBSDKLoginButtonDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            let loginButton = FBSDKLoginButton()
        
            loginButton.frame = CGRect(x:16,y:500, width: view.frame.width-40,height:50)
            loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            view.addSubview(loginButton)
        
            loginButton.delegate = self
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout of facebook")
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)

        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully Loggedin Facebook")
        showDetail()
        
        performSegue(withIdentifier: "login", sender: nil)
        

        
    }
    func loggedIn() {
        
        let accessToken = FBSDKAccessToken.current()
        guard (accessToken?.tokenString) != nil else{return}
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, first_name, last_name,link"]).start { (connection, result, error) in
            
            if error != nil{
                print("Failed to Login", error as Any)
            }
            let resultdict = result as? NSDictionary
            let idvalue = resultdict?["id"] as? String
            print("the id value is \(String(describing: idvalue))")
            UserDefaults.standard.set(idvalue, forKey: "id")
            
            
            let firstName = resultdict?["first_name"] as? String
            print("the firstName value is \(String(describing: firstName))")
            UserDefaults.standard.set(firstName, forKey: "first_name")
            
            
            let lastName = resultdict?["last_name"] as? String
            print("the lastName value is \(String(describing: lastName))")
            UserDefaults.standard.set(lastName, forKey: "last_name")
            
            let link = resultdict?["link"] as? String
            print("the link value is \(String(describing: link))")
            UserDefaults.standard.set(link, forKey: "link")
            
            let facebookProfileUrl = "http://graph.facebook.com/\(idvalue!)/picture?width=100&height=100"
            UserDefaults.standard.set(facebookProfileUrl, forKey: "profilepic")
            
            print(result as Any)
            
        }

        
    }
    
    func showDetail(){
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else{return}
        
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil
            {
                print("Something wrong with our FB user:", error as Any)
            }
            
            print("Successfully Login with our user:",user as Any)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, first_name, last_name,link"]).start { (connection, result, error) in
            
            if error != nil{
                print("Failed to Login", error as Any)
            }
            let resultdict = result as? NSDictionary
            let idvalue = resultdict?["id"] as? String
                print("the id value is \(String(describing: idvalue))")
                UserDefaults.standard.set(idvalue, forKey: "id")
            
            
            let firstName = resultdict?["first_name"] as? String
                print("the firstName value is \(String(describing: firstName))")
                UserDefaults.standard.set(firstName, forKey: "first_name")
        
        
            let lastName = resultdict?["last_name"] as? String 
                print("the lastName value is \(String(describing: lastName))")
                UserDefaults.standard.set(lastName, forKey: "last_name")
            
            let link = resultdict?["link"] as? String
            print("the link value is \(String(describing: link))")
            UserDefaults.standard.set(link, forKey: "link")
            
            let facebookProfileUrl = "http://graph.facebook.com/\(idvalue!)/picture?width=100&height=100"
            UserDefaults.standard.set(facebookProfileUrl, forKey: "profilepic")
            
            print(result as Any)

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

