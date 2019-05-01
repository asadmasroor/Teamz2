//
//  PublishedSquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 14/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class PublishedSquadViewController: UITableViewController {
    
    let realm : Realm
    
    var selectedClubName : String?
    var selectedSquadName : String?
    var selectedFixtureName : String?
    
    
    let allClubs: Results<Club>
    var club : Results<Club>? = nil
    var squad : Results<Squad>? = nil
    var fixture : Results<Fixture>? = nil
    
     var notificationToken: NotificationToken?
    
    var selectedPlayers = List<Confirmation>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPublishedSquad()
        
        notificationToken = selectedPlayers.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadPublishedSquad()
                
                //                tableView.beginUpdates()
                //                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                //                                     with: .automatic)
                //                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                //                                     with: .automatic)
                //                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                //                                     with: .automatic)
            //                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPlayers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publishedCell", for: indexPath) as! PublishedSquadTableViewCell
        
        let player = selectedPlayers[indexPath.row]

        if player.available == true {
             cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
            cell.usernameLabel.text = player.user?.username
            cell.statusLabel.text = "Confirmed"
            
            
        } else if player.available == false {
            cell.backgroundColor = UIColor(red:0.26, green:0.54, blue:0.98, alpha:1.0)
            cell.usernameLabel.text = player.user?.username
            cell.statusLabel.text = "Awaiting for confirmation"
        }

        return cell
    }
    

    func loadPublishedSquad() {
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        club = realm.objects(Club.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "name = %@", "\((selectedSquadName)!)")
        squad = club![0].squads.filter(predicate1)
        
        let predicate2 = NSPredicate(format: "title = %@", "\((selectedFixtureName)!)")
        fixture = squad![0].fixtures.filter(predicate2)
        
        
        
        selectedPlayers = fixture![0].publishedSquad
        
        tableView.reloadData()
    }

}
