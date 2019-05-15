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

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return clubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell", for: indexPath) as! ClubTableViewCell
        
        cell.clubLabel.text = clubs[indexPath.row].name
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "squadchallenegeSegue") {
            let barViewControllers = segue.destination as! SquadChallenegeTab
            let destinationViewController = barViewControllers.viewControllers?[0] as! SquadViewController
           
            destinationViewController.selectedClubName = clubs[indexPath1].name
            
            let destinationViewController1 = barViewControllers.viewControllers?[1] as! ChallengeViewController
            
            
            destinationViewController1.selectedClubName = clubs[indexPath1].name
            
            let destinationViewController2 = barViewControllers.viewControllers?[2] as! requestsTableViewController
            
            destinationViewController2.selectedClubName = clubs[indexPath1].name
            
       
        }
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = indexPath.row
        
        performSegue(withIdentifier: "squadchallenegeSegue", sender: self)
    
        
    }
    
    func loadClubs() {
       
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
    }
    


}
