//
//  JoinedSquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
class JoinedSquadViewController: UITableViewController {
    
    var indexPath1 = 0
    
    let realm: Realm
    var allClubs : Results<Club>
    var squads = List<Squad>()
    var selectedClubName : String?
    var notificationToken : NotificationToken?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
//        let predicate = NSPredicate(format: "name = %@", "\((self.selectedClubName)!)")
        self.allClubs = realm.objects(Club.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
     //    let predicate = NSPredicate(format: "name = %@", "\((self.selectedClubName)!)")
         self.allClubs = realm.objects(Club.self)
       
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSquads()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self!.loadSquads()
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadSquads()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return squads.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "squadCell", for: indexPath) as! JoinedSquadTableViewCell

        cell.squadLabel.text = squads[indexPath.row].name

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JoinedFixturesViewController
        
        destinationVC.selectedClubName = selectedClubName
        destinationVC.selectedSquadName = squads[indexPath1].name
    
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = indexPath.row
        
        performSegue(withIdentifier: "joinedFixtureSegue", sender: self)
    }


    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadSquads() {
        
       // squads.removeAll()
    
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club = allClubs.filter(predicate)
        squads = club[0].squads
        
        tableView.reloadData()
    }
}
