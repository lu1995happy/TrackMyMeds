//
//  ViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/29.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit
import GoogleSignIn


class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailField.layer.cornerRadius = 10.0
        passwordField.layer.cornerRadius = 10.0
        loginButton.layer.cornerRadius = 10.0
        signInButton.layer.cornerRadius = 10.0
        registerButton.layer.cornerRadius = 10.0
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = "1087531044438-36t78d3taoi26t6urto8odd7cu85j6dg.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        
        //GIDSignIn.sharedInstance().signInSilently()
        
        
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Here")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error) != nil {
            print(error)
        }
        else {
            JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: "Loading", andFooter: "Please Wait")
            //let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            let email = user.profile.email
            let profileImage = user.profile.imageURL(withDimension: 300)
            //let vc = ViewController()
            
            //print("\(profileImage)")
            
            UserDefaults.standard.set(fullName, forKey: "userName")
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(profileImage, forKey: "userImageURL")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            JHProgressHUD.sharedHUD.hide()
            performSegue(withIdentifier: "Homepage", sender: self)
            
        }
    }
    
    
  //  func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
  //  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let foundUser = UserInfo.mr_findFirst(byAttribute: "userEmail", withValue: emailField.text!)
        
         if (foundUser != nil) {
            if passwordField.text == foundUser?.password {
                
                UserDefaults.standard.set(foundUser?.userName, forKey: "userName")
                UserDefaults.standard.set(foundUser?.userEmail, forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "userImageURL")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                performSegue(withIdentifier: "Homepage", sender: self)
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Invalid Password", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }
        }
        else
         {
            let alert = UIAlertController(title: "Error", message: "User with this email not found", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
 
        }
        
    }


}

