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
    
    var notificationToken : NotificationToken?
    
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
      loadFixtures()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self!.loadFixtures()
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadFixtures()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
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
    
    func availableButtonPressed(cell: JoinedFixtureViewCell) {
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "title = %@", "\(self.fixtures[(indexPath?.row)!].title)")
        let fixture = self.realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\((userLoggedIn[0].username))")
        let user = fixture[0].availablePlayers.filter(predicate1)
        
        if user.count == 0 {
            
            let available = Available()
            available.user = userLoggedIn[0]
            available.available = true
            
            
            try! realm.write {
                realm.add(available)
                fixture[iPath].availablePlayers.append(available)
            }
        
        } else {
            try! realm.write {
                user[0].available = true
            }
            
        }
        
        loadFixtures()
        
    }
    
    func notAvailableButtonPressed(cell: JoinedFixtureViewCell) {
       
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "title = %@", "\(fixtures[(indexPath?.row)!].title)")
        let fixture = self.realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\((userLoggedIn[0].username))")
        let user = fixture[0].availablePlayers.filter(predicate1)
        
        if user.count == 0 {
            
            print("hello")
            let available = Available()
            available.user = userLoggedIn[0]
            available.available = false
            
            
            try! realm.write {
                realm.add(available)
                fixture[iPath].availablePlayers.append(available)
            }
            
        } else {
            
            try! realm.write {
                user[0].available = false
            }

            
        }
        
        loadFixtures()
    }
    
    
  
    
    
    func challengeButtonPressed(cell: JoinedFixtureViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        print(iPath)
        
        performSegue(withIdentifier: "joinedChallengeSegue", sender: self)
    }
    
    
    

    
 
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//
//
//    }

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
        
        tableView.reloadData()
        
    }
//
//    func addAvailbility(available: Available){
//
//        try! realm.write {
//            realm.add(available)
//        }
//
//    }
}
