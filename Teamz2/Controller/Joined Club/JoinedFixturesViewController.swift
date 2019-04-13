//
//  JoinedFixturesViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class JoinedFixturesViewController: UITableViewController, joinedFixtureDelegate {
    
    
     let realm = try! Realm()
    var iPath = 0
    
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

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fixtures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! JoinedFixtureViewCell
        
        cell.setFixture(fixture: fixtures[indexPath.row])
        cell.delegate = self
        
        for available in fixtures[indexPath.row].availablePlayers {
            if (available.user?.username ==  userLoggedIn?.username) {
                if (available.available == true) {
                    cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
                    cell.accessoryType = .checkmark
                    
                } else if  (available.available == false){
                   
                    cell.accessoryType = .none
                }
            }
        }
        

        return cell
    }
    
    func challengeButtonPressed(cell: JoinedFixtureViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        print(iPath)
        
        performSegue(withIdentifier: "joinedChallengeSegue", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JoinedChallengesViewController
        
        destinationVC.selectedFixture = fixtures[iPath]
        destinationVC.userLoggedIn = userLoggedIn
    }
    
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let predicate = NSPredicate(format: "title = %@", "\(fixtures[indexPath.row].title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
        let user = fixture[0].availablePlayers.filter(predicate1)
        
      
        
        
        let predicate2 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
        let available = realm.objects(Available.self).filter(predicate2)
        
        if available[0].parentFixture[0].title == fixtures[indexPath.row].title {
            
            try! realm.write {
                
            
                
                user[0].available = !user[0].available

                
                
                self.tableView.reloadData()
                
                
                
            }
            
        }
        
    }


}
