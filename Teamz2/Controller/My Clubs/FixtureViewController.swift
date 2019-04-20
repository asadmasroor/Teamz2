//
//  FixtureViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class FixtureViewController: UITableViewController, cellDelegateChallenge {
    
    
    
    let realm = try! Realm()
    
    
    // Global variable to store the indexpath of the table
    var uIndexPath = 0
    
    // Store fixtures of the current club's squad
    var fixtures = List<Fixture>()
    
    var selectedSquad : Squad? {
        didSet {
            fixtures = (selectedSquad?.fixtures)!
        }
    }
    
    var userLoggedIn : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fixtures.count
    }
    
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! FixtureTableViewCell
        
        let fixture = fixtures[indexPath.row]
        
        cell.setFixture(fixture: fixture)
        cell.delegate = self

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       
        
        if (segue.identifier == "tabSegue") {
            
            
            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers?[0] as! SelectionViewController
            destinationViewController.userLoggedIn = userLoggedIn
            destinationViewController.selectedFixture = fixtures[uIndexPath]
            
             let destinationViewController1 = barViewControllers.viewControllers?[1] as! PublishedSquadViewController
            
            destinationViewController1.userLoggedIn = userLoggedIn
            destinationViewController1.selectedFixture = fixtures[uIndexPath]
            
        }
        
        
        
    }
    
 
    func challengeButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "challengeSegue", sender: self)
    }
    
    
    
    func selectionButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "tabSegue", sender: self)
    }
    
    

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var addressField = UITextField()
        let newClubAlert = UIAlertController(title: "Add New Fixture", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newFixture = Fixture()
            newFixture.title = (textField.text)!
            newFixture.address = (addressField.text)!
            
            self.fixtures.append(newFixture)
            
            self.tableView.reloadData()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            newClubAlert.dismiss(animated: true, completion: nil)
        }
        
        newClubAlert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter title for fixture"
            textField = UITextField
        }
        
        newClubAlert.addTextField { (UIAddressTextField) in
            UIAddressTextField.placeholder = "Enter address for fixture"
            addressField = UIAddressTextField
        }
        
        newClubAlert.addAction(action)
        newClubAlert.addAction(cancelAction)
        
        present(newClubAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated:     true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Delete?", message: "Are you sure you want to delete \(self.fixtures[indexPath.row].title)?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                
                
                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
                let predicate = NSPredicate(format: "title = %@", "\(self.fixtures[indexPath.row].title)")
                let fixture = self.realm.objects(Fixture.self).filter(predicate)
                try! self.realm.write {
                    
                    if fixture.count != 0 {
                        self.fixtures.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.realm.delete(fixture[0])
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
}

