//
//  makeChallenegeController.swift
//  Teamz2
//
//  Created by Asad Masroor on 18/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class makeChallenegeController: UIViewController {
    
    let realm = try! Realm()
     var club: Results<Club>? = nil 
    
    var SelectedClub : Club? {
        didSet {
            let predicate = NSPredicate(format: "name = %@", "\((SelectedClub?.name)!)")
            club = realm.objects(Club.self).filter(predicate)
        }
    }
    
   
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var expiryTF: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         showDatePicker()
      

        // Do any additional setup after loading the view.
    }
    
   
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        expiryTF.inputAccessoryView = toolbar
        expiryTF.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        expiryTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        if (nameTF.text?.count != 0) && (descriptionTV.text.count != 0) && (expiryTF.text?.count != 0) {
            
            let confirmation = UIAlertController(title: "Add New Challenege", message: "Are you sure you want to add this new challenege to the Club?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                try! self.realm.write {
                    let challenege = Challenge()
                    challenege.name = self.nameTF.text!
                    challenege.club = self.SelectedClub
                    challenege.expirydate = self.datePicker.date
                    challenege.desc = self.descriptionTV.text!
                    
                    self.realm.add(challenege)
                    self.club?[0].challenges.append(challenege)
                    
                    
                    
                }
                
                self.navigationController?.popViewController(animated: true)
              
             }
            
            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (UIAlertAction) in
                confirmation.dismiss(animated: true, completion: nil)
            }
            
            confirmation.addAction(yesAction)
            confirmation.addAction(cancelAction)
            
            present(confirmation, animated: true, completion: nil)
            
            
        } else {
            let fillAlert = UIAlertController(title: "Fill in all the fields", message: "", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
                fillAlert.dismiss(animated: true, completion: nil)
            }
            
           fillAlert.addAction(yesAction)
           present(fillAlert, animated: true, completion: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


