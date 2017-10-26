//
//  AlarmViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/30.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var allAlarm: [Alarm]!
    let cellReuseIdentifier = "AlarmCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        //self.edgesForExtendedLayout = []
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(10,0,0,0)
        
        self.tableView.backgroundColor = UIColor.clear
        
        fetchAllAlarm()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllAlarm()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAllAlarm() {
        
        allAlarm = Alarm.mr_findAll() as! [Alarm]!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        if allAlarm.count == 0 {
            
            noDataLabel.isHidden = false
            noDataLabel.text          = "No alarm added. Add new alarm \nby pressing the add key icon on top right."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 3
            noDataLabel.backgroundColor = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0;
        }
        else {
            noDataLabel.backgroundColor = UIColor.clear
            noDataLabel.isHidden = true
            tableView.backgroundView  = nil
            return allAlarm.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        let ala = self.allAlarm[indexPath.row]
        
        if let medicineName = ala.medicineName
        {
        cell.textLabel?.text = "\(medicineName)"
        }
        //cell.detailTextLabel?.text =
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let tempAcc = self.allAlarm[indexPath.row]
            tempAcc.mr_deleteEntity()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            self.allAlarm.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempAla = self.allAlarm[indexPath.row]
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmAddEdit") as! AddAlarmViewController
        
        myVC.alarm = tempAla
        
        self.navigationController?.pushViewController(myVC, animated: true)
        
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }

}
