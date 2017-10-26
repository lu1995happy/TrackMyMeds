//
//  MedicineDetailsViewController.swift
//  TrackMyMeds
//
//  Created by 天霖 陆 on 2017/4/5.
//  Copyright © 2017年 天霖 陆. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class MedicineDetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var feelingTextField: UITextField!
    @IBOutlet var noOfTimesLabel: UILabel!
    @IBOutlet var dosageLabel: UILabel!
    @IBOutlet var mediColorImage: UIImageView!
    @IBOutlet var mediShapeImage: UIImageView!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var brandNameLabel: UILabel!
    
    var medi: Medicine?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feelingTextField.delegate = self
        
        if medi != nil {
            
            if let medDos = medi?.medDosage
            {
            self.dosageLabel.text = "Dosage: \(medDos)"
            }
            self.title = medi?.medName
            if let braNam = medi?.brandName
            {
            brandNameLabel.text = "Brand: \(braNam)"
            }
            descTextView.text = medi?.mediDescription
            feelingTextField.text = medi?.lastFeeling
            if let noOFTime = medi?.noOfTimesTaken
            {
            noOfTimesLabel.text = "\(noOFTime)"
            }
            mediColorImage.image = UIImage(named: (medi?.colorImg)!)
            mediShapeImage.image = UIImage(named: (medi?.appearImg)!)
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == feelingTextField
        {
            self.view.endEditing(true)
            
            showFeelingPicker(textField: textField)
            
            return false
        }
        else
        {
            return true
        }
    }
    
    func showFeelingPicker(textField: UITextField) {
        
        ActionSheetStringPicker.show(withTitle: "How are you feeling", rows: ["Feeling: Better", "Feeling: Same", "Feeling: Worse"], initialSelection: 1, doneBlock: {
            picker, index, value  in
            
            if let dosageValue = value as? String {
                textField.text = dosageValue
                
                if self.medi != nil {
                    self.medi?.lastFeeling = dosageValue
                    
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                }
            }
            
            //textField.text = "\(value!)"
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: textField)
        
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
