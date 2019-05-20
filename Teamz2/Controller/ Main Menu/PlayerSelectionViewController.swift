//
//  PlayerSelectionViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 11/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerSelectionViewController: UITableViewController, playerSelectionDelegate {
  
    
    let realm: Realm
    let fixtures: Results<Fixture>
    let confirmations: Results<Confirmation>
    let userLoggedIn: Results<User>
    var selectedFixtures = List<Fixture>()
    var publishedSquad = List<Confirmation>()
    var notificationToken: NotificationToken?
    var stringUser : [String] = []
    var number : [Int] = []
    
    //intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.fixtures = realm.objects(Fixture.self)
        self.confirmations = realm.objects(Confirmation.self)
        
        
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.userLoggedIn = realm.objects(User.self).filter(predicate)
        super.init(nibName: nil, bundle: nil)
    }
    
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.fixtures = realm.objects(Fixture.self)
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        self.userLoggedIn = realm.objects(User.self).filter(predicate)
         self.confirmations = realm.objects(Confirmation.self)
        super.init(coder: aDecoder)
    }
    
    //function that execuetes when the view controller loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadSelectedFixtures()
    
        notificationToken = confirmations.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                
                self?.loadSelectedFixtures()
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.loadSelectedFixtures()
                tableView.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
    }

    // MARK: - Table view data source
    //Methods to populate table with data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return selectedFixtures.count
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! PlayerSelectionViewCell

        
        if selectedFixtures.count != 0  {
            let fixture1 = selectedFixtures[indexPath.row]
            
            let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath.row].title)")
            let fixture = realm.objects(Fixture.self).filter(predicate)
            
            let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn[0].username)")
            let user = fixture[0].publishedSquad.filter(predicate1)
            
            if user[0].available == true {
                cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
                cell.confirmButton.isHidden = true
                cell.decideButton.isHidden = false
                cell.statusLabel.text = "Status: Selection Confirmed"
            } else if (user[0].available == false) {
            cell.backgroundColor = UIColor(red:0.26, green:0.54, blue:0.98, alpha:1.0)
             cell.decideButton.isHidden = true
                cell.confirmButton.isHidden = false
                cell.statusLabel.text = "Status: Awaiting Decision"
            }
      
            cell.titleLabel.text = fixture1.title
            cell.dateLabel.text = "Date: \(cell.formatDate(date: fixture1.date)) Time:\(cell.formatTime(date: fixture1.time))"
            cell.addressLabel.text =  fixture1.address
        } else {
            
            cell.titleLabel.isHidden = true
            cell.addressLabel.isHidden = true
            cell.textLabel?.text = "You have not been selected yet."
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor(red:0.00, green:0.51, blue:1.00, alpha:1.0)
            cell.confirmButton.isHidden = true
            cell.declineButton.isHidden = true
           self.tableView.rowHeight = 50
            
            
        }
        
        
       
        
        cell.delegate = self

        return cell
    }
    
    //Loads all the fixture that the player has been selected
    func loadSelectedFixtures() {
        
        selectedFixtures.removeAll()
        
        for fixture in fixtures {
            
            publishedSquad = fixture.publishedSquad
            
            for user in publishedSquad {
                if user.user?.owner ==  userLoggedIn[0].owner {
                    selectedFixtures.append(fixture)
                }
            }
            
        }
        
       
        tableView.reloadData()
    }
 

    //MARK: Buttons pressed
    
    // function that executes when user presses deciderlater button
    func decideButtonPressed(cell: PlayerSelectionViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        
        let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath!.row].title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn[0].username)")
        let user = fixture[0].publishedSquad.filter(predicate1)
        
        
        print(fixture[0].title)
        try! realm.write {
            
            user[0].available = false
            
            
            self.tableView.reloadData()
            
        }
        loadSelectedFixtures()
    }
    
    //function that executes when user confirms his selection
    func confirmButtonPressed(cell: PlayerSelectionViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        

        let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath!.row].title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn[0].username)")
        let user = fixture[0].publishedSquad.filter(predicate1)
        
        
        print(fixture[0].title)
         try! realm.write {
            
            user[0].available = true
            
            
           self.tableView.reloadData()

        }
        
        
      
        
    }

    // function that excutes when user declines his selection
    func declineButtonPressed(cell: PlayerSelectionViewCell) {
        
        let declineAlert = UIAlertController(title: "Decline selection for this fixture?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            let indexPath = self.tableView.indexPath(for: cell)
            
            
            let predicate = NSPredicate(format: "title = %@", "\(self.selectedFixtures[indexPath!.row].title)")
            let fixture = self.realm.objects(Fixture.self).filter(predicate)
            
            let predicate1 = NSPredicate(format: "user.username = %@", "\(self.userLoggedIn[0].username)")
            //let user = fixture[0].publishedSquad.filter(predicate1)
            
            
            let confirmations = self.realm.objects(Confirmation.self)
            
            
            try! self.realm.write {
                
                self.tableView.reloadData()
                
                var count = -1
                for confirmation in confirmations {
                    count += 1
                    if ((confirmation.user?.username == (self.userLoggedIn[0].username)) && (confirmation.fixture?.title == self.selectedFixtures[indexPath!.row].title)){
                        self.realm.delete(confirmations[count])
                    }
                }
                self.loadSelectedFixtures()
                self.tableView.reloadData()
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            declineAlert.dismiss(animated: true, completion: nil)
        }
        
        
        declineAlert.addAction(yesAction)
        declineAlert.addAction(cancelAction)
        
        present(declineAlert, animated: true, completion: nil)
        
        
    }

}
