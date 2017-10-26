//
//  AlarmNotificationViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/4/7.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit

class AlarmNotificationViewController: UIViewController {

    @IBOutlet var mediTypeImage: UIImageView!
    @IBOutlet var mediImageColor: UIImageView!
    @IBOutlet var mediNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var recievedAlarm: Alarm!
    var allAlarm: [Alarm]!
    var selectedDate: Date!
    
    var mediLog: MedLog!
     var allMedLog: [MedLog]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (recievedAlarm) != nil {
            timeLabel.text = recievedAlarm.alarmTLabel
            mediNameLabel.text = recievedAlarm.medicine?.medName
            //appearImg
            mediImageColor.image = UIImage(named: (recievedAlarm.medicine?.colorImg)!)
            mediTypeImage.image = UIImage(named: (recievedAlarm.medicine?.appearImg)!)
        }
        
        fetchAllAlarm()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchAllAlarm() {
        
        allAlarm = Alarm.mr_findAll() as! [Alarm]!
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
    @IBAction func takenPressed(_ sender: Any) {
        
        
        if let medName = mediNameLabel.text
        {
            let medFind = Medicine.mr_findFirst(byAttribute: "medName", withValue: medName)
            
            if (medFind != nil) {
                medFind?.noOfTimesTaken+=1
            }
        }

        mediLog = MedLog.mr_createEntity()
            
        mediLog.dateAdded = selectedDate! as NSDate
        mediLog.mediName = mediNameLabel.text
        mediLog.status = "Taken"
        mediLog.medicine?.adding(recievedAlarm.medicine!)
            
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        let alert = UIAlertController(title: "Success", message: "Information successfully updated", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func skipPressed(_ sender: Any) {
        
        
//            mediLog = MedLog.mr_createEntity()
//            
//            mediLog.dateAdded = selectedDate! as NSDate
//            mediLog.mediName = mediNameLabel.text
//            mediLog.status = "Skipped"
//            mediLog.medicine = recievedAlarm.medicine?.alarm
//            
//            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()

        let alert = UIAlertController(title: "Success", message: "Information successfully updated", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
    @IBAction func backPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
*/
    

}
