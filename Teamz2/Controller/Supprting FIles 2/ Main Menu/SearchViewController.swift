//
//  SearchViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UITableViewController, SearchClubDelegate {
    
    var indexpath = 0
    
   let realm: Realm
    
    var userLoggedIn : User?

    var allClubs : Results<Club>
    var allClubNames : [String] = []
    var joinedClubNames : [String] = []
    var notJoinedClubNames : [String] = []
    //var notJoined = List<Club>()
    var notJoinedClubs: Results<Club>? = nil
    var user: Results<User>? = nil
    
    var notificationToken : NotificationToken?

    
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
        
        loadUnjoinedClubs()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                 self!.loadUnjoinedClubs()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadUnjoinedClubs()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    
        
    }
    
    
    func loadUnjoinedClubs() {
        
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        user = realm.objects(User.self).filter(predicate)
        
       
        
        for club in allClubs {
            
            allClubNames.append("\(club.name)")
            
        }
        
        
        for club in (user![0].joinedClubs) {
            joinedClubNames.append("\(club.name)")
        }
        
        
        for club in allClubNames {
            if joinedClubNames.contains(club){
                print("\(club) joined")
            } else {
                print("\(club) not joined")
                notJoinedClubNames.append(club)
            }
        }
        
        
        let predicate1 = NSPredicate(format: "name IN %@", notJoinedClubNames)
        notJoinedClubs = realm.objects(Club.self).filter(predicate1)
        
       tableView.reloadData()
        
        
        
    }
 
    func joinButtonPressed(cell: SearchTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        indexpath = indexPath!.row
        
        let predicate = NSPredicate(format: "name = %@", "\(notJoinedClubs![indexpath].name)")
        let club = realm.objects(Club.self).filter(predicate)
        
        print(club[0].name)

        
        let predicate1 = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        let user1 = club[0].requests.filter(predicate1)

        if user1.count == 0 {
            
            try! realm.write {
                club[0].requests.append(user![0])
                
            }
        }
        
        
        
        tableView.reloadData()
       // loadUnjoinedClubs()
       }
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (notJoinedClubs != nil) && (notJoinedClubs!.count != 0) {
            return notJoinedClubs!.count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notJoinedClubCell", for: indexPath) as! SearchTableViewCell
        
        
        if (notJoinedClubs != nil) && (notJoinedClubs!.count != 0){
            cell.nameLabel.text = notJoinedClubs![indexPath.row].name
            cell.descLabel.text = "Amatuer Sports Club"
            
            let predicate = NSPredicate(format: "name = %@", "\(notJoinedClubs![indexPath.row].name)")
            let club = realm.objects(Club.self).filter(predicate)

            let predicate1 = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
            let user = club[0].requests.filter(predicate1)

            if (user.count != 0 ){
                
                print(user[0].username)

                cell.backgroundColor = UIColor.gray
                cell.joinButton.isHidden = true
                cell.requestedLabel.isHidden = false
                //tableView.reloadData()
            }
           
        } else {
            cell.textLabel?.text = "No Clubs G"
            cell.nameLabel.isHidden = true
            cell.descLabel.isHidden = true
            cell.joinButton.isHidden = true
            tableView.reloadData()
        }
        
        
        cell.delegate = self
        return cell
    }


    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 210
        tableView.rowHeight = UITableView.automaticDimension
        
    }



}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        notJoinedClubs = notJoinedClubs?.filter("name CONTAINS[cd] %@", searchBar.text!)
      
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {


            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

        }
    }
    
}
