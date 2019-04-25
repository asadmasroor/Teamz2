//
//  MakeNewFixture.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class MakeNewFixture: UIViewController, UITextFieldDelegate {
    
    let realm: Realm
    var club: Results<Club>? = nil
    var squad: Results<Squad>? = nil
    
    var SelectedClubName : String? {
        
        didSet {
            let predicate = NSPredicate(format: "name = %@", "\((SelectedClubName)!)")
            club = realm.objects(Club.self).filter(predicate)
        }
    }
    
    var SelectedSquadName : String? {
        
        didSet {
            let predicate = NSPredicate(format: "name = %@", "\((SelectedSquadName)!)")
            if club?.count != 0 {
                squad = club![0].squads.filter(predicate)
            }
        }
    }
    
    
    

    @IBOutlet weak var fixtureTitleTF: UITextField!
    @IBOutlet weak var fixtureAddressTF: UITextView!
    @IBOutlet weak var fixtureDateTF: UITextField!
    @IBOutlet weak var fixtureTimeTF: UITextField!
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fixtureDateTF.delegate = self
        fixtureTimeTF.delegate = self
        
        
        showDatePicker()
        showTimePicker()
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fixtureDateTF {
            showDatePicker()
        } else {
            showTimePicker()
        }
        
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
        
        fixtureDateTF.inputAccessoryView = toolbar
        fixtureDateTF.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        fixtureDateTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
   
    func showTimePicker(){
        //Formate Date
        datePicker.datePickerMode = .time
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        fixtureTimeTF.inputAccessoryView = toolbar
        fixtureTimeTF.inputView = datePicker
        
    }
    
    @objc func doneTimePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        fixtureTimeTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker(){
        self.view.endEditing(true)
    }

    
    @IBAction func addFIxtureButtonPrssed(_ sender: Any) {
        
        if (fixtureTitleTF.text?.count != 0) && (fixtureAddressTF.text.count != 0) && (fixtureDateTF.text?.count != 0) && (fixtureTimeTF.text?.count != 0){
            
            let confirmation = UIAlertController(title: "Add New Fixture", message: "Are you sure you want to add this new Fixture to the Club?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                try! self.realm.write {
                    let fixture = Fixture()
                    
                    fixture.title = self.fixtureTitleTF.text!
                    fixture.address = self.fixtureAddressTF.text!
                    fixture.date = self.datePicker.date
                    fixture.time = self.timePicker.date
                    
                    self.realm.add(fixture)
                    self.squad![0].fixtures.append(fixture)
                    
                    print("hello")
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
    
}
