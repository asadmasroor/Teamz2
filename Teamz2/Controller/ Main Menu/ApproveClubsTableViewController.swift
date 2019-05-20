//
//  ApproveClubsTableViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ApproveClubsTableViewController: UITableViewController, clubRequestsDelegate {
    
    var clubs = List<Club>()
    var allClubs1 : Results<Club>
    var indexPath1 = 0
    let realm: Realm
    var notificationToken : NotificationToken?
    
    //intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
         self.allClubs1 = realm.objects(Club.self)
        super.init(nibName: nil, bundle: nil)
    }
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
         self.allClubs1 = realm.objects(Club.self)
        super.init(coder: aDecoder)
        
    }

    //function that executes when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClubs()
        
        notificationToken = allClubs1.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.loadClubs()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadClubs()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    // MARK: - Table view data source
    // functions to populate the table with data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubRequestCell", for: indexPath) as! ClubRequestsViewCell
        
        cell.delegate = self
        
        cell.clubNameLabel.text = clubs[indexPath.row].name
    
        return cell
    }
 
    // function that executes when accept button is pressed
    func acceptButtonPressed(cell: ClubRequestsViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "name = %@", "\(clubs[indexPath!.row].name)")
        let club = realm.objects(Club.self).filter(predicate)
        
        try! realm.write {
            club[0].approved = true
        }
        
        loadClubs()
    }

    // function that excutes when decline button is pressed
    func declineButtonPressed(cell: ClubRequestsViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "name = %@", "\(clubs[indexPath!.row].name)")
        let club = realm.objects(Club.self).filter(predicate)
        
        try! realm.write {
            realm.delete(club[0])
        }
        loadClubs()
    }
    
    
    // function to retrieve clubs that need approval from database in realm cloud
    func loadClubs() {
        
       
        let allClubs = realm.objects(Club.self)
        clubs.removeAll()
        for club in allClubs {
            if club.approved == false {
                    clubs.append(club)
                }
                
            }
        print(clubs.count)
        tableView.reloadData()
    }

}
