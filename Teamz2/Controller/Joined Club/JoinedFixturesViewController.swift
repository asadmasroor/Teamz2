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
    
    let realm: Realm
    
    var iPath = 0
    
    var fixtures = List<Fixture>()
    let tick = "\u{2705}"
    let cross = "\u{274c}"
    
    var allClubs : Results<Club>
    var userLoggedIn : Results<User>
    
    var selectedSquadName : String?
    var selectedClubName : String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
         let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.userLoggedIn = realm.objects(User.self).filter(predicate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.userLoggedIn = realm.objects(User.self).filter(predicate)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fixtures.count == 0 ? 1 : fixtures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! JoinedFixtureViewCell
        cell.delegate = self
        
        if (fixtures.count != 0){
            cell.setFixture(fixture: fixtures[indexPath.row])
            
            
            for available in fixtures[indexPath.row].availablePlayers {
                if (available.user?.username ==  userLoggedIn[0].username) {
                    if (available.available == true) {
                        cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
                        //   cell.accessoryType = .checkmark
                        
                    } else if  (available.available == false){
                        cell.backgroundColor = UIColor(red:0.00, green:0.51, blue:1.00, alpha:1.0)
                        //    cell.accessoryType = .none
                    }
                }
            }
        } else {
            cell.textLabel?.text = "No fixture's yet"
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "title = %@", "\(self.fixtures[indexPath.row].title)")
        let fixture = self.realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(self.userLoggedIn[0].username)")
        let user = fixture[0].availablePlayers.filter(predicate1)
        
        
        let predicate2 = NSPredicate(format: "user.username = %@", "\(userLoggedIn[0].username)")
        let available = self.realm.objects(Available.self).filter(predicate2)
        
        let makeAvailable = UIContextualAction(style: .normal, title: "\(tick)") { (action, self, nil) in
            
            try! realm.write {
                user[0].available = true
                
               tableView.reloadData()
                
            }
        }
        
       
        
        makeAvailable.backgroundColor = UIColor.white
        
        let notAvailable = UIContextualAction(style: .normal, title: "\(cross)") { (action, self, nil) in
            
            try! realm.write {
                user[0].available = false
                
                tableView.reloadData()
                
            }
        }
        
        notAvailable.backgroundColor = UIColor.gray
        
        let configuration = UISwipeActionsConfiguration(actions: [makeAvailable, notAvailable])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func challengeButtonPressed(cell: JoinedFixtureViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        print(iPath)
        
        performSegue(withIdentifier: "joinedChallengeSegue", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JoinedChallengesViewController
        
       // destinationVC.selectedFixture = fixtures[iPath]
        //destinationVC.userLoggedIn = userLoggedIn[0]
    }
    
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadFixtures() {
        
        fixtures.removeAll()
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club = allClubs.filter(predicate)
        
        if club.count != 0 {
             let predicate = NSPredicate(format: "name = %@", "\((selectedSquadName)!)")
            let squad = club[0].squads.filter(predicate)
            
            if squad.count != 0 {
                for fixture in squad[0].fixtures {
                    fixtures.append(fixture)
                }
            }
        }
        
        
    }
}
