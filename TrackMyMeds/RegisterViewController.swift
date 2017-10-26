//
//  RegisterViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/4/6.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var registerButton: UIButton!
    @IBOutlet var passwordAgainField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var fullNameField: UITextField!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var closeButton: UIButton!
    
    //var newUser: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10.0
        passwordAgainField.layer.cornerRadius = 10.0
        passwordField.layer.cornerRadius = 10.0
        emailField.layer.cornerRadius = 10.0
        fullNameField.layer.cornerRadius = 10.0
        closeButton.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func isValidEmail(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if isValidEmail(email: emailField.text!) {
            
        if passwordField.text == passwordAgainField.text {
            //if !(emailField.text == "") {
                if !(fullNameField.text == "") {
                    //do the magic here
                        let foundUser = UserInfo.mr_findFirst(byAttribute: "userEmail", withValue: emailField.text!)
                        
                        //print("\(foundUser)")
                        
                        if (foundUser != nil) {
                            
                            let alert = UIAlertController(title: "Info", message: "User with this email already exist", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        else
                        {
                            
                            let newUser = UserInfo.mr_createEntity()
                            
                            newUser?.userName = fullNameField.text
                            newUser?.userEmail = emailField.text
                            newUser?.password = passwordField.text
                            
                            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: "Kindly enter your name", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)

                }
            //}//email field
            /*else
            {
                let alert = UIAlertController(title: "Error", message: "Email is required", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
 
            }*/
        }//password
        else
        {
            let alert = UIAlertController(title: "Error", message: "Password is not same in both fields", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        }
            }//email validity if
        else
        {
            let alert = UIAlertController(title: "Error", message: "Email is not valid", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

}
