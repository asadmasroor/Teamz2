//
//  MembersTableViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class MembersTableViewController: UITableViewController {
    
    let realm: Realm
    let allClubs: Results<Club>
    var clubMembers : List<User>?
    var selectedClubName : String?
    var selectedClub : Club?
   let UserLoggedIn: Results<User>
    
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.UserLoggedIn = realm.objects(User.self).filter(predicate)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.UserLoggedIn = realm.objects(User.self).filter(predicate)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tabBarController?.navigationItem.title = "Members"
        loadMembers()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
          
            switch changes {
            case .initial:
                self?.loadMembers()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.loadMembers()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Members"
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubMembers!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath)
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = clubMembers![indexPath.row].username
        
        
    
   

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Remove \(self.clubMembers![indexPath.row].username)?", message: "Are you sure you want to remove \(self.clubMembers![indexPath.row].username) from \(self.selectedClubName!)?", preferredStyle: .alert)
            
            
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                
                
                let predicate1 = NSPredicate(format: "username == %@", "\(self.clubMembers![indexPath.row].username)")
                let user = self.realm.objects(User.self).filter(predicate1)
                
                //Deleting club from user joined club list
                for (index, club) in user[0].joinedClubs.enumerated() {
                    if club.name == self.selectedClubName! {
                        try! self.realm.write {
                            print("hiiiii 22")
                            user[0].joinedClubs.remove(at: index)
                            //self.realm.delete(self.UserLoggedIn[0].joinedClubs[index])
                        }
                        break
                    }
                }
                
                
                let predicate = NSPredicate(format: "name == %@", "\(self.selectedClubName!)")
                let club1 = self.realm.objects(Club.self).filter(predicate)
                
                for (index, user) in club1[0].members.enumerated() {
                    if user.username ==  self.clubMembers?[index].username {
                        try! self.realm.write {
                            print("hiiiii")
                            club1[0].members.remove(at: index)
                            
                            //                            self.realm.delete(club1[0].members[index])
                        }
                        break
                    }
                }
                
                
                
          
            
                
                self.loadMembers()
                
               
            })
            
            
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (UIAlertAction) in
                confirmation.dismiss(animated: true, completion: nil)
            }
            
            confirmation.addAction(yesAction)
            confirmation.addAction(cancelAction)
            
            self.present(confirmation, animated: true, completion: nil)
            
        }
        
        return [deleteAction]
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func loadMembers(){
        
        let predicate = NSPredicate(format: "name == %@", "\(selectedClubName!)")
        let club = realm.objects(Club.self).filter(predicate)
        selectedClub = club[0]
        clubMembers = club[0].members
        tableView.reloadData()
    }
    
    

}
