//
//  JoinedClubViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class JoinedClubViewController: UITableViewController {
    
    let realm: Realm

    var indexpath1 = 0
    
    var joinedClubs = List<Club>()
  
    let UserLoggedIn: Results<User>
    
    
    
    var notificationToken : NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.UserLoggedIn = realm.objects(User.self).filter(predicate)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.UserLoggedIn = realm.objects(User.self).filter(predicate)
        super.init(coder: aDecoder)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadJoinedClubs()
        
        notificationToken = UserLoggedIn.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self!.loadJoinedClubs()
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                  self!.loadJoinedClubs()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
      
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return joinedClubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedclubCell", for: indexPath) as! JoinedClubTableViewCell
        
        cell.clubLabel.text = joinedClubs[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desitinationVC =  segue.destination as! JoinedSquadViewController
        
        desitinationVC.selectedClubName = joinedClubs[indexpath1].name
        print("hi: \(joinedClubs[indexpath1].name)")
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexpath1 = indexPath.row
        performSegue(withIdentifier: "joinedSquadSegue", sender: nil)
    }
    
    
    func loadJoinedClubs(){
       
        joinedClubs.removeAll()
        
        for club in UserLoggedIn[0].joinedClubs {
            joinedClubs.append(club)
        }
        tableView.reloadData()
    }

}
