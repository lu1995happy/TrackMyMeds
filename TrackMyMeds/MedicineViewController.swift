//
//  MedicineViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/18.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit

class MedicineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "medicineCell"
    
    //var med: Medicine!
    var allMed: [Medicine]!

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.edgesForExtendedLayout = []
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(10,0,0,0)
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG.png"))
        
        fetchAllMed()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMed()
        self.tableView.reloadData()
    }
    
    func fetchAllMed() {
        
        allMed = Medicine.mr_findAll() as! [Medicine]!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        if allMed.count == 0 {
            
            noDataLabel.isHidden = false
            
            noDataLabel.text          = "No medicine added. Add new medicine \nby pressing the add key icon on top right."
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
            return allMed.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        let med = self.allMed[indexPath.row]
        
        cell.textLabel?.text = med.medName
        cell.detailTextLabel?.text = med.medDosage
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let tempAcc = self.allMed[indexPath.row]
            tempAcc.mr_deleteEntity()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            self.allMed.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempMed = self.allMed[indexPath.row]
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MediDetailsVC") as! MedicineDetailsViewController
        
        myVC.medi = tempMed
        
        self.navigationController?.pushViewController(myVC, animated: true)
        
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

}
