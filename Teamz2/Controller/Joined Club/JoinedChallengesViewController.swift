//
//  JoinedChallengesViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class JoinedChallengesViewController: UITableViewController, joinedChallengeDelegate  {
   
    let realm : Realm
    
    var iPath = 0
    
    var challenges = List<Challenge>()
    
    var allClubs : Results<Club>
    var userLoggedIn : Results<User>
    
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
       
        loadChallenges()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
               self!.loadChallenges()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadChallenges()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

       
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return challenges.count == 0 ? 1 : challenges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedChallengeCell", for: indexPath) as! JoinedChallengeViewCell
        
        if challenges.count != 0 {
            let challenge = challenges[indexPath.row]
            
            
            let time = cell.calculateTimeleft(expiryDate: challenge.expirydate)
            
            
            cell.setChallenge(challenge: challenge)
        } else {
            cell.textLabel?.text = "No Challenges"
            cell.clubLabel.isHidden = true
            cell.descriptionLabel.isHidden = true
            cell.milesLabel.isHidden = true
            cell.nameLabel.isHidden = true
            
        }
        
        cell.delegate = self

        return cell
    }
    
   
 
    func attemptChallenegeButtonPressed(cell: JoinedChallengeViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        
        
        performSegue(withIdentifier: "attemptChallenegeSegue", sender: self)
    }
    
    func viewAttemptsButtonPressed(cell: JoinedChallengeViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        performSegue(withIdentifier: "viewAttemptSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "attemptChallenegeSegue") {
            let destinationVC = segue.destination as! AttemptChallengeController
            
            destinationVC.selectedChallenge = challenges[iPath]
            destinationVC.userLoggedIn = userLoggedIn[0]
        }
        
        if (segue.identifier == "viewAttemptSegue") {
            let destinationVC = segue.destination as! ChallenegeAttemptsViewController
             destinationVC.userLoggedIn = userLoggedIn[0]
             destinationVC.selectedChallenge = challenges[iPath]
            
        }
        
        
    }
    
    

    @IBAction func homeButtonPressed(_ sender: Any) {
//        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadChallenges() {
        challenges.removeAll()
        
        
        for club in allClubs {
            for challenge in club.challenges {
                challenges.append(challenge)
            }
        }
        
        tableView.reloadData()
        
    }
    

}
