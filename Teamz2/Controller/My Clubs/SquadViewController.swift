//
//  SquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SquadViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var squads = List<Squad>()
    var findexPath = 0
    
    var selectedClub : Club? {
        didSet {
            squads = (selectedClub?.squads)!
        }
    }
    
    var UserLoggedIn : User?

    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Squads"
    }

    // MARK: - Table view data source

  
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
        
        destinationVC.selectedSquad = squads[findexPath]
        destinationVC.userLoggedIn = UserLoggedIn
        
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
                
               
                
                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
                let predicate = NSPredicate(format: "name = %@", "\(self.squads[indexPath.row].name)")
                let squad = self.realm.objects(Squad.self).filter(predicate)
                try! self.realm.write {
                    
                    if squad.count != 0 {
                        self.squads.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.realm.delete(squad[0])
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
 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let newSquadAlert = UIAlertController(title: "Make New Squad", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newSquad = Squad()
            newSquad.name = (textField.text)!
            self.selectedClub?.squads.append(newSquad)
            
            self.tableView.reloadData()
            
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
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)    }
}
