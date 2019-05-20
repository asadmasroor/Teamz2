//
//  ClubViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
class ClubViewController: UITableViewController {
    
    var clubs = List<Club>()
    var allClubs : Results<Club>
    let realm: Realm
    var indexPath1 = 0
    var notificationToken : NotificationToken?
    
    //initaliser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        super.init(nibName: nil, bundle: nil)
    }
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.allClubs = realm.objects(Club.self)
        super.init(coder: aDecoder)
    }
    
    //function that loads up when the table view loads up
    override func viewDidLoad() {
        super.viewDidLoad()
        
      loadClubs()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
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
    
    //functions to populate data into table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return clubs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell", for: indexPath) as! ClubTableViewCell
        
        cell.clubLabel.text = clubs[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //function for swipe functionality
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            let confirmation = UIAlertController(title: "Delete?", message: "Are you sure you want to delete \(self.clubs[indexPath.row].name)?", preferredStyle: .alert)

            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in

                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
                let predicate = NSPredicate(format: "name = %@", "\(self.clubs[indexPath.row].name)")
                let club = self.realm.objects(Club.self).filter(predicate)
                try! self.realm.write {

                    if club.count != 0 {
                        self.realm.delete(club[0])
                        self.loadClubs()

                    }

                }

            }

            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (UIAlertAction) in
                confirmation.dismiss(animated: true, completion: nil)
            }

            confirmation.addAction(yesAction)
            confirmation.addAction(cancelAction)

            self.present(confirmation, animated: true, completion: nil)

        }

        return [deleteAction]
    }
    
    // function for when user clicks on row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = indexPath.row
        
        performSegue(withIdentifier: "squadchallenegeSegue", sender: self)
        
    }

    // function to prepare for when the view is changed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "squadchallenegeSegue") {
            let barViewControllers = segue.destination as! SquadChallenegeTab
            let destinationViewController = barViewControllers.viewControllers?[0] as! SquadViewController
           
            destinationViewController.selectedClubName = clubs[indexPath1].name
            
            let destinationViewController1 = barViewControllers.viewControllers?[1] as! ChallengeViewController
            
            
            destinationViewController1.selectedClubName = clubs[indexPath1].name
            
            let destinationViewController2 = barViewControllers.viewControllers?[2] as! requestsTableViewController
            
            destinationViewController2.selectedClubName = clubs[indexPath1].name
            
            let destinationViewController3 = barViewControllers.viewControllers?[3] as! MembersTableViewController
            
            destinationViewController3.selectedClubName = clubs[indexPath1].name
            
       
        }
        
        
       
    }
    
    

    // function to retrieve users clubs from the database in the realm cloud
    func loadClubs() {
       
        clubs.removeAll()
        
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        let user = realm.objects(User.self).filter(predicate)
        
        if user.count != 0 {
            let myClubs = user[0].clubs
            
            for club in myClubs {
                
                if club.approved == true {
                    clubs.append(club)
                }
                
            }
        }
        
        tableView.reloadData()
    }
    
    //deintialiser
    deinit {
        notificationToken?.invalidate()
    }

}
