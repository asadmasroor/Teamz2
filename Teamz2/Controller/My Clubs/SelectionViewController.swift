//
//  SelectionViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var availablePlayers : List<Available>?
    var selectedPlayers : List<User>?
    var userLoggedIn : User?
    var availablePLayersName : [String] = []
    
  
    var selectedFixture : Fixture? {
        didSet{
           
            // availablePlayers = (selectedFixture?.availablePlayers)!
            
            
        }
    }
    
    override func viewDidLoad() {
       
        let predicate = NSPredicate(format: "title = %@", "\((selectedFixture?.title)!)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        print(fixture.count)
        print("Pree In")

        if fixture.count != 0 {
        
        
        availablePlayers = fixture[0].availablePlayers
        print("In")
       
        
        
        
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
        
        cell.playerNameLabel.text = availablePlayers?[indexPath.row].user?.name
        
        if(availablePlayers?[indexPath.row].available == true){
            cell.accessoryType = .checkmark
        } else {
             cell.accessoryType = .none
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
       
        if(availablePlayers?[indexPath.row].available == true){
            
            try! realm.write {
                availablePlayers?[indexPath.row].available = false
            }
            
           
            
        } else {
            try! realm.write {
                availablePlayers?[indexPath.row].available = true
            }
        }

        
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
 
    
    
    
}
