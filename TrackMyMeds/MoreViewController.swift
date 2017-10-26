//
//  MoreViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/29.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var mediName = ["About", "Logout"]
    //var imgName = ["About", "Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.edgesForExtendedLayout = []
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)
        
        cell.textLabel?.text = mediName[indexPath.row]
        
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "Learn More About Us"
            cell.imageView?.image = UIImage(named: "About")
        case 1:
            cell.detailTextLabel?.text = "Logout of your account"
            cell.imageView?.image = UIImage(named: "Logout")
        default:
            cell.detailTextLabel?.text = "Logout of your account"
            cell.imageView?.image = UIImage(named: "Logout")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if indexPath.row == 1 {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC")
            
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        else if indexPath.row == 0 {
            
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoVC")
            
            self.navigationController?.pushViewController(myVC!, animated: true)
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
