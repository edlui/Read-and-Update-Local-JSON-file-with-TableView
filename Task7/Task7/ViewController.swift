//
//  ViewController.swift
//  Task7
//
//  Created by Eddie Lui on 14/5/19.
//  Copyright © 2019 Eddie Lui. All rights reserved.
//

import UIKit

let dateFormatter = DateFormatter()

class ViewController: UIViewController {
    
    @IBOutlet weak var dob3: UIDatePicker!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var cteam: UITextView!
    private var datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        setupTexts()
        setupEditButton()
    }
    
    func setupTexts() {
        fname.text = athleteList[currentIndex].firstname
        lname.text = athleteList[currentIndex].lastname
        dob3.date = dateFormatter.date(from: athleteList[currentIndex].yob)!
        cteam.text = athleteList[currentIndex].team
        dob3.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func validate() -> Bool{
        if(fname.text!.isEmpty || lname.text!.isEmpty || cteam.text!.isEmpty ){
            return false
        }
        return true
    }
    
    func writeToFile(location: URL) {
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let JsonData = try encoder.encode(athleteList)
            try JsonData.write(to: location)
        }catch{}
    }
    
    func setupEditButton(){
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(tappedEditButton))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setupSaveButton(){
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tappedSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func tappedEditButton() {
        
        setupSaveButton()
        
        fname.isUserInteractionEnabled = true
        fname.borderStyle = .roundedRect
        fname.backgroundColor = .white
        fname.textColor = .black
        
        lname.isUserInteractionEnabled = true
        lname.borderStyle = .roundedRect
        lname.backgroundColor = .white
        lname.textColor = .black
        
        cteam.isEditable = true
        cteam.backgroundColor = .white
        cteam.textColor = .black
        
        dob3.isUserInteractionEnabled = true

    }
    
    @objc func tappedSaveButton() {
        
        if validate() == true{
            athleteList[currentIndex].yob = dateFormatter.string(from: dob3.date)
            athleteList[currentIndex].firstname = fname.text!
            athleteList[currentIndex].lastname = lname.text!
            athleteList[currentIndex].team = cteam.text!
            
            setupEditButton()
            
            fname.isUserInteractionEnabled = false
            fname.borderStyle = .none

            lname.isUserInteractionEnabled = false
            lname.borderStyle = .none

            cteam.isEditable = false
            
            dob3.isUserInteractionEnabled = false
            
            fresult = true
            
            if fresult == true{
                writeToFile(location: subUrl!)
                fresult = false
            }
        }else {
            let alert = UIAlertController(title: "Reminder:", message: "All fields are required!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
