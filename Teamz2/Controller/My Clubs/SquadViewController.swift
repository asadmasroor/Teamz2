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
}
