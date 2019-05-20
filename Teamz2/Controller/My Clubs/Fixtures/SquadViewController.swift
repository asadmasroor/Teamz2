//
//  SquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
import Validation
import Log

class SquadViewController: UITableViewController {
    let Log = Logger()
    let realm: Realm
    var selectedClubName : String?
    var squads = List<Squad>()
    var findexPath = 0
    
    
    //intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(coder: aDecoder)
    }
    
    //function that executes when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadSquads()
        
    }
    
    //function that excutes when the view will appears
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "Squads"
        
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSqaud))
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [addBarButton, homeButton]
        
        
        
    }
        
    //function that excutes when the user wants to add new squad
    @objc func addNewSqaud() {
            var validation = Validation()
            validation.minimumLength = 1
            validation.maximumLength = 20
            
            var textField = UITextField()
            let newSquadAlert = UIAlertController(title: "Make New Squad", message: "", preferredStyle: .alert)
            
            let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
                
                let startTime = CFAbsoluteTimeGetCurrent()
                
                if (validation.validateString(textField.text!)) {
                    if !(self.checkSquadExists(name: textField.text!)) {
                        let predicate = NSPredicate(format: "name = %@", "\((self.selectedClubName)!)")
                        let club = self.realm.objects(Club.self).filter(predicate)
                        
                        let newSquad = Squad()
                        newSquad.name = (textField.text)!
                        
                        if club.count != 0 {
                            try! self.realm.write {
                                club[0].squads.append(newSquad)
                            }
                        }
                        
                        self.loadSquads()
                        
                        self.tableView.reloadData()
                    } else {
                        self.presentSquadExistsAlert(name: textField.text!)
                    }
                } else {
                    self.presentErrorAlert()
                }
                
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                self.Log.info("Time elapsed for adding new Squad: \(timeElapsed) s.")
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
                newSquadAlert.dismiss(animated: true, completion: nil)
            }
            
            newSquadAlert.addTextField { (UITextField) in
                UITextField.placeholder = "Enter name for squad"
                textField = UITextField
            }
            
            newSquadAlert.addAction(action)
            newSquadAlert.addAction(cancelAction)
            
            present(newSquadAlert, animated: true, completion: nil)
            
        }
        
    //function to take user back to the main screen.
    @objc func home() {
            navigationController?.popToRootViewController(animated: true)
            
        }

    // MARK: - Table view data source

    //functions to populate the table with data
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return squads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "squadCell", for: indexPath) as! SquadTableViewCell
        
        cell.squadLabel.text = squads[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FixtureViewController
        
        destinationVC.selectedSquadName = squads[findexPath].name
        destinationVC.selectedClubName = selectedClubName

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        findexPath = indexPath.row
        
        performSegue(withIdentifier: "fixtureSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Delete?", message: "Are you sure you want to delete \(self.squads[indexPath.row].name)?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                let predicate = NSPredicate(format: "name = %@", "\((self.selectedClubName)!)")
                let club = self.realm.objects(Club.self).filter(predicate)
                
                let predicate2 = NSPredicate(format: "name = %@", "\(self.squads[indexPath.row].name)")
                let squad = club[0].squads.filter(predicate2)
                
                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
               
               
                try! self.realm.write {
                    
                    if squad.count != 0 {
                        self.squads.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.realm.delete(squad[0])
                        self.loadSquads()
                    }
                    
                    
                }
                
                
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (UIAlertAction) in
                confirmation.dismiss(animated: true, completion: nil)
            }
            
            confirmation.addAction(yesAction)
            confirmation.addAction(cancelAction)
            
            self.present(confirmation, animated: true, completion: nil)
            
        }
        
        return [deleteAction]
    }
    
    
    // function to load squads from the database in the cloud
    func loadSquads(){
        
        squads.removeAll()
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club = realm.objects(Club.self).filter(predicate)
        
        if club.count != 0 {
            let clubSquads = club[0].squads
            
            for squad in clubSquads {
                squads.append(squad)
            }
        }
    }
    
    // function to check if a squad exists already
    func checkSquadExists(name: String) -> Bool{
        var exists = false
        let predicate = NSPredicate(format: "name = %@", "\((self.selectedClubName)!)")
        let club = self.realm.objects(Club.self).filter(predicate)
        
        let squads = club[0].squads
        
        for squad in squads {
            if squad.name == name {
                exists = true
            }
        }
        
        return exists
    }
    
    // function to present an error alert
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "Please enter valid squad name. Between 1-20 characters.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            errorAlert.dismiss(animated: true, completion: nil)
        }
        
        errorAlert.addAction(okayAction)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    // function to present an error alert - squad exsts
    func presentSquadExistsAlert(name: String) {
        let okayAlert = UIAlertController(title: "Error", message: "Squad with name '\(name)' already exists!", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            okayAlert.dismiss(animated: true, completion: nil)
        }
        
        okayAlert.addAction(okayAction)
        
        present(okayAlert, animated: true, completion: nil)
    }
        
}
    

    

