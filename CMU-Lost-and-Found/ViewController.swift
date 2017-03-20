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
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully Loggedin Facebook")
        showDetail()
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
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, error) in
            
            if error != nil{
                print("Failed to Login", error as Any)
            }
            
            print(result as Any)

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

