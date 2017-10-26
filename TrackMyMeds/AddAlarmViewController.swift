//
//  AddAlarmViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/30.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import UserNotifications

class AddAlarmViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var mediNameField: UITextField!
    @IBOutlet var timeField: UITextField!
    
    
    var allMed: [Medicine]!
    var alarm: Alarm?
    var thisMed: Medicine!
    //var allMedString: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if alarm == nil {
            self.navigationItem.title = "Add Alarm"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        }
        else
        {
            self.navigationItem.title = "Edit Alarm"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(addTapped))
            
            self.timeField.text = alarm?.alarmTLabel
            self.mediNameField.text = alarm?.medicine?.medName
            
        }
        
        // Do any additional setup after loading the view.
        mediNameField.delegate = self
        timeField.delegate = self
        fetchAllMed()
        
        //scheduleNotification(at: Date+30)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMed()
    }
    
    func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Track My Meds"
        content.subtitle = "It's time for your medicine"
        if let medName = mediNameField.text, let medTime = timeField.text
        {
            content.body = "\(medName)"
            content.userInfo = ["MedName":"\(medName)","MedTime": "\(medTime)"]
        }
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        
//        request.content.userInfo = ["Time":"Morning"]
        
//        request.setValue("Morning", forKey: "Time")
        
//        request.content.setValue("morning", forKey: "time")
        
        
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }

    
    func addTapped() {
        if !(mediNameField.text?.isEmpty)!
        {
            
            alarm?.alarmTLabel = timeField.text
            alarm?.medicineName = mediNameField.text
            alarm?.medicine = thisMed
            
            //print("\(alarm?.alarmDT as! Date)")
            
            if (timeField.text != "") {
                
                if let alarmSecTime = alarm?.alarmDT
                {
                    scheduleNotification(at: alarmSecTime as Date)
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                }
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Selecting time is a must", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }

            _ = self.navigationController?.popToRootViewController(animated: true)

        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mediNameField
        {
            self.view.endEditing(true)
            
            if allMed.count==0 {
                let alert = UIAlertController(title: "Error", message: "You haven't added any medicine yet.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
               showMedicinesPicker(textField: textField)
            }
            
            return false
        }
        else if textField == timeField
        {
            self.view.endEditing(true)
            showDatePicker(textField: textField)
            return false
        }
        else
        {
            return true
        }
    }
    
    func showDatePicker(textField: UITextField) {
        let datePicker = ActionSheetDatePicker(title: "Select Time", datePickerMode: UIDatePickerMode.time, selectedDate: NSDate() as Date!, doneBlock: {
            picker, value, index in
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "h:mm a"
            
            let fullFormatter = DateFormatter()
            fullFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateString = dateFormater.string(from: value as! Date)
            //let fullDateString = fullFormatter.string(from: value as! Date+86400)
            
            if self.alarm == nil {
                self.alarm = Alarm.mr_createEntity()
            }
            
            let myDate = value as! Date
            self.alarm?.alarmDT = myDate as NSDate?
            
            //print(value as! Date+86400)
            
            self.timeField.text = dateString
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: textField)
        
        datePicker?.minuteInterval = 1
        datePicker?.show()

    }
    
    func showMedicinesPicker(textField: UITextField) {
        
        let arr = allMed.map{$0.medName}
        
        ActionSheetStringPicker.show(withTitle: "Select Medicine", rows: arr as Any as! [Any], initialSelection: 0, doneBlock: {
            picker, index, value  in
            
            //print("\(value)")
            
            //let med = self.allMed[index]
            
            self.thisMed = self.allMed[index]
            
             if let medValue = value as? String {
                 textField.text = "\(medValue)"
             }
            
            //textField.text = "\(med.medName!)"
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: textField)
        
    }

    
    func fetchAllMed() {
        
        allMed = Medicine.mr_findAll() as! [Medicine]!
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
