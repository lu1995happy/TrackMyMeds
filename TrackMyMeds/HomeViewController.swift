//
//  HomeViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/3/30.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit
import FSCalendar
import ActionSheetPicker_3_0


class HomeViewController: UIViewController, UITextFieldDelegate, FSCalendarDataSource, FSCalendarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellReuseIdentifier = "ScheduleCell"
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var calendar: FSCalendar!
    
    //@IBOutlet var tableView: UITableView!
    @IBOutlet var selectedMedicine: UITextField!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userWelcomeMessage: UILabel!
    
    @IBOutlet var medNameView: UIView!
    //@IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var allMed: [Medicine]!
    var allAlarm: [Alarm]!
    var allMedLog: [MedLog]!
    var selectedDt: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.scope = .week
        
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        
        self.medNameView.layer.masksToBounds = false
        self.medNameView.layer.shadowColor = UIColor.black.cgColor
        self.medNameView.layer.shadowOpacity = 0.5
        self.medNameView.layer.shadowOffset = CGSize(width: 1, height: -0.5)
        self.medNameView.layer.shadowRadius = 1
        
        self.userImage.layer.cornerRadius = 10.0
        
        if (UserDefaults.standard.string(forKey: "userName") != nil) {
            
            if let welcomeMessage = UserDefaults.standard.string(forKey: "userName") {
                userWelcomeMessage.text = "Welcome \(welcomeMessage)"
            }
            
            //print("\(UserDefaults.standard.url(forKey: "userImageURL"))")
            //self.userWelcomeMessage.text = "Welcome \(UserDefaults.standard.string(forKey: "userName"))"
        }
        
        if (UserDefaults.standard.url(forKey: "userImageURL") != nil) {
            
            //let url = URL(string: UserDefaults.standard.url(forKey: "userImageURL")!)
            let data = try? Data(contentsOf: UserDefaults.standard.url(forKey: "userImageURL")!)
            userImage.image = UIImage(data: data!)
            
            self.userImage.layer.cornerRadius = self.userImage.frame.width/2
            
        }
        
        if selectedDt == nil {
            selectedDt = Date()
        }
        
        selectedMedicine.delegate = self
        fetchAllMed()
        fetchAllAlarm()
        //fetchAllMedLog()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllMed()
        fetchAllAlarm()
        self.collectionView.reloadData()
    }
    
    func fetchAllMed() {
        
        allMed = Medicine.mr_findAll() as! [Medicine]!
    }
    
    func fetchAllMedLog() {
        
        allMedLog = MedLog.mr_findAll() as! [MedLog]!
    }
    
    func fetchAllAlarm() {
        
        if let selectedMed = selectedMedicine.text
        {
        let predicate = NSPredicate(format: "medicineName == %@", selectedMed)
        allAlarm = Alarm.mr_findAll(with: predicate) as! [Alarm]!
            //print("Count: \(allAlarm.count)")
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectedMedicine
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
        else
        {
            return true
        }
    }
    
    func showMedicinesPicker(textField: UITextField) {
        
        let arr = allMed.map{$0.medName}
        
        ActionSheetStringPicker.show(withTitle: "Select Medicine", rows: arr as Any as! [Any] , initialSelection: 0, doneBlock: {
            picker, index, value  in
            
            //let med = self.allMed[index]
            
            if let medValue = value as? String {
                textField.text = "\(medValue)"
                self.fetchAllAlarm()
            }
            self.collectionView.reloadData()
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: textField)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- FSCalender
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarHeightConstraint.constant = bounds.height
        
        //print(bounds.height)
        
        //self.calendar.frame.size.height = bounds.height
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDt = date
        //print("Date Selected: \(date)")
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(calendar.currentPage)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        
        if allMed.count==0 {
            noDataLabel.isHidden = false
            noDataLabel.text          = "No medicine added."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 3
            noDataLabel.backgroundColor = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
            //collectionView.separatorStyle  = .none
            return 0;
        }
        else if (selectedMedicine.text == "")
        {
            noDataLabel.isHidden = false
            noDataLabel.text          = "No medicine selected. \nSelect medicine to view it's data."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 3
            noDataLabel.backgroundColor = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
            //collectionView.separatorStyle  = .none
            return 0;
        }
        else if allAlarm.count==0{
            noDataLabel.isHidden = false
            if let medName = selectedMedicine.text
            {
            noDataLabel.text          = "No alarm added for \(medName). Goto alarm to add an alarm."
            }
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 3
            noDataLabel.backgroundColor = UIColor.white
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
            //collectionView.separatorStyle  = .none
            return 0;

        }
        else
        {
            noDataLabel.isHidden = true
            collectionView.backgroundView  = nil
            collectionView.backgroundColor = UIColor.clear
            return allAlarm.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        let tempAlarm = allAlarm[indexPath.row]
        
        //cell.medicineNameLabel.text = tempAlarm.medicineName
        //cell.labelOfStatus.text = tempAlarm.alarmTLabel
        cell.labelOfStatus.text = tempAlarm.alarmTLabel
        
        
        //let result = selectedDt.compare(tempAlarm.alarmDT! as Date)
        
            
        if let alaDT = tempAlarm.alarmDT
        {
            let hour = Calendar.current.component(.hour, from: alaDT as Date)
            
            if hour >= 0 && hour < 12 {
                cell.imageOfTime.image = UIImage(named: "Morning")
            } else if hour >= 12 && hour < 16 {
                cell.imageOfTime.image = UIImage(named: "Noon")
            } else if hour >= 16 && hour < 18 {
                cell.imageOfTime.image = UIImage(named: "Evening")
            } else if hour >= 18 {
                cell.imageOfTime.image = UIImage(named: "Night")
            }
        }
        //cell.imageOfAlarm
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmNotiVC") as! AlarmNotificationViewController
        
        vc.recievedAlarm = allAlarm[indexPath.row]
        
        if let dt = selectedDt {
            vc.selectedDate = dt
        }
        else
        {
            vc.selectedDate = Date()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)

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
