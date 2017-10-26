//
//  UserViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/29.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//
import UIKit

class UserViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userAge: UILabel!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var doctorNameField: UITextField!
    @IBOutlet var userHeightField: UITextField!
    
    @IBOutlet var doctorPhoneField: UITextField!
    @IBOutlet var dobField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    
    @IBOutlet var updateEditButton: UIBarButtonItem!
    var user: UserInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userImage.layer.cornerRadius = self.userImage.frame.width/2
        
        if let usrName = UserDefaults.standard.string(forKey: "userName") {
            userName.text = usrName
        }
        
        updateEditButton.title = "Edit"
        
        if updateEditButton.title == "Edit" {
            doctorNameField.isEnabled = false
            userHeightField.isEnabled = false
            
            doctorPhoneField.isEnabled = false
            dobField.isEnabled = false
            userWeightField.isEnabled = false
            
        }
        else
        {
            doctorNameField.isEnabled = true
            userHeightField.isEnabled = true
            
            doctorPhoneField.isEnabled = true
            dobField.isEnabled = true
            userWeightField.isEnabled = true
        }
        
        if let usrEmail = UserDefaults.standard.string(forKey: "userEmail") {
            userAge.text = usrEmail
            user = UserInfo.mr_findFirst(byAttribute: "userEmail", withValue: usrEmail)
            dobField.text =  user?.userAge
            userWeightField.text = user?.userWeight
            userHeightField.text = user?.userHeight
            doctorNameField.text = user?.doctorName
            doctorPhoneField.text = user?.doctorPhone
        }
        
        if (UserDefaults.standard.url(forKey: "userImageURL") != nil) {
            
            //let url = URL(string: UserDefaults.standard.url(forKey: "userImageURL")!)
            let data = try? Data(contentsOf: UserDefaults.standard.url(forKey: "userImageURL")!)
            userImage.image = UIImage(data: data!)
            
            self.userImage.layer.cornerRadius = self.userImage.frame.width/2
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updatePressed(_ sender: Any) {
        
        
        
        
        if updateEditButton.title == "Edit" {
            updateEditButton.title = "Update"
            
            doctorNameField.isEnabled = true
            userHeightField.isEnabled = true
            
            doctorPhoneField.isEnabled = true
            dobField.isEnabled = true
            userWeightField.isEnabled = true
            
            self.userHeightField.becomeFirstResponder()
            
        }
        else
        {
            
            let foundUser = UserInfo.mr_findFirst(byAttribute: "userEmail", withValue: userAge.text!)
            
            if (foundUser != nil) {
                foundUser?.userAge = dobField.text
                foundUser?.userWeight = userWeightField.text
                foundUser?.userHeight = userHeightField.text
                foundUser?.doctorName = doctorNameField.text
                foundUser?.doctorPhone = doctorPhoneField.text
                
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                
                let alert = UIAlertController(title: "Success", message: "User information is updated", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let newUser = UserInfo.mr_createEntity()
                
                newUser?.userName = userName.text
                newUser?.userEmail = userAge.text
                newUser?.userAge = dobField.text
                newUser?.userWeight = userWeightField.text
                newUser?.userHeight = userHeightField.text
                newUser?.doctorName = doctorNameField.text
                newUser?.doctorPhone = doctorPhoneField.text
                
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                
                let alert = UIAlertController(title: "Success", message: "User information is updated", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            updateEditButton.title = "Edit"
            doctorNameField.isEnabled = false
            userHeightField.isEnabled = false
            
            doctorPhoneField.isEnabled = false
            dobField.isEnabled = false
            userWeightField.isEnabled = false
        }
        
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
