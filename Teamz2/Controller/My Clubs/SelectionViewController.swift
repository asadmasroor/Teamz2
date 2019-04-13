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
    
    var availablePlayers = List<Available>()
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
    

        if fixture.count != 0 {
        
        let predicate1 = NSPredicate(format: "available = true")
        let availablePlayers1 = fixture[0].availablePlayers.filter(predicate1)
        
            for players in availablePlayers1 {
                availablePlayers.append(players)
            }
     
       
        
        
        
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
        
        cell.playerNameLabel.text = availablePlayers[indexPath.row].user?.name
        
        if(availablePlayers[indexPath.row].isSelected == true){
            cell.accessoryType = .checkmark
        } else {
             cell.accessoryType = .none
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
       
        if(availablePlayers[indexPath.row].isSelected == true){
            
            try! realm.write {
                availablePlayers[indexPath.row].isSelected = false
            }
            
           
            
        } else {
            try! realm.write {
                availablePlayers[indexPath.row].isSelected = true
            }
        }

        
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
 
    @IBAction func publishButtonPressed(_ sender: Any) {
        
        let predicate = NSPredicate(format: "title = %@", "\((selectedFixture?.title)!)")
        let fixture = self.realm.objects(Fixture.self).filter(predicate)
        
        try! realm.write {
            fixture[0].publishedSquad.removeAll()
        }
        
        
        for user in availablePlayers{
            if user.isSelected == true {
                try! realm.write {
                    let confirmation = Confirmation()
                    confirmation.user = user.user
                    fixture[0].publishedSquad.append(confirmation)
                }
            }
        }
        
    }
    
    
    
}
