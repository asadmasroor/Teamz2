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
    
    var availablePlayers : List<User>?
    var selectedPlayers : List<User>?
    var userLoggedIn : User?
    var availablePLayersName : [String] = []
    
  
    var selectedFixture : Fixture? {
        didSet{
           
            availablePlayers = (selectedFixture?.availablePlayers)!
            
            
        }
    }
    
    override func viewDidLoad() {
       
        let predicate = NSPredicate(format: "title = %@", "\(selectedFixture?.title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        print(fixture.count)
        
        if fixture.count != 0 {
        
        
        availablePlayers = fixture[0].availablePlayers
        print("In")
       
        
        for player in selectedPlayers! {
            
            availablePLayersName.append(player.name)
        }
        
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
        
        cell.playerNameLabel.text = availablePlayers?[indexPath.row].name
        
        if (availablePLayersName.contains((availablePlayers?[indexPath.row].name)!)) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
       
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
//            try! realm.write {
//
//                let predicate = NSPredicate(format: "title = %@", "\(selectedFixture?.title)")
//                let fixture = realm.objects(Fixture.self).filter(predicate)
//
//                if fixture != nil {
//                    fixture[0].selectedPlayers.remove(at: indexPath.row)
//                }
//
//            }
            
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
//               try! realm.write {
//
//                let predicate = NSPredicate(format: "title = %@", "\(selectedFixture?.title)")
//                let fixture = realm.objects(Fixture.self).filter(predicate)
//
//                if fixture != nil {
//                    fixture[0].selectedPlayers.append(selectedPlayers![indexPath.row])
//                }
//
//            }
        }
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
 
    
    
    
}
