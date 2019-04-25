//
//  FixtureViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class FixtureViewController: UITableViewController, cellDelegateChallenge {
    
    
    
    let realm: Realm

    // Global variable to store the indexpath of the table
    var uIndexPath = 0
    
    // Store fixtures of the current club's squad
    var fixtures = List<Fixture>()
    var selectedSquadName : String?
    var selectedClubName: String?
    var notificationToken: NotificationToken?
    let club: Results<Club>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.club = realm.objects(Club.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.club = realm.objects(Club.self)
        
        super.init(coder: aDecoder)
    }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFixtures()
        
        
        notificationToken = club.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadFixtures()
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
    
    override func viewDidAppear(_ animated: Bool) {
        loadFixtures()
        
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fixtures.count == 0 ? 1 : fixtures.count
//        result = binaryCondition ? valueReturnedIfTrue : valueReturnedIfFalse;
    }
    
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! FixtureTableViewCell
        
        if fixtures.count != 0 {
            let fixture = fixtures[indexPath.row]
            
            cell.setFixture(fixture: fixture)
            cell.delegate = self
        } else {
            cell.textLabel?.text = "No Fixture's yet"
            cell.addressLabel.isHidden = true
            cell.datetimeLabel.isHidden = true
            cell.titleLabel.isHidden = true
            cell.selectionButton.isHidden = true
            
            
        }
       
        
    

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       
        
        if (segue.identifier == "tabSegue") {
            
            
            let barViewControllers = segue.destination as! UITabBarController
            let destinationViewController = barViewControllers.viewControllers?[0] as! SelectionViewController
         //   destinationViewController.userLoggedIn = userLoggedIn
            destinationViewController.selectedFixture = fixtures[uIndexPath]
            
             let destinationViewController1 = barViewControllers.viewControllers?[1] as! PublishedSquadViewController
            
      //      destinationViewController1.userLoggedIn = userLoggedIn
            destinationViewController1.selectedFixture = fixtures[uIndexPath]
            
        }
        
        if (segue.identifier == "newFixtureSegue") {
            
            
            let destinationVC = segue.destination as! MakeNewFixture
            destinationVC.SelectedClubName = selectedClubName
            destinationVC.SelectedSquadName = selectedSquadName
           
            
        }
        
        
        
    }
    
 
    func challengeButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "challengeSegue", sender: self)
    }
    
    
    
    func selectionButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "tabSegue", sender: self)
    }
    
    

    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "newFixtureSegue", sender: self)
    }
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated:     true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (fixtures.count != 0) {
         return true
        }
        else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Delete?", message: "Are you sure you want to delete \(self.fixtures[indexPath.row].title)?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                
                
                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
                let predicate = NSPredicate(format: "title = %@", "\(self.fixtures[indexPath.row].title)")
                let fixture = self.realm.objects(Fixture.self).filter(predicate)
                try! self.realm.write {
                    
                    if fixture.count != 0 {
                        self.fixtures.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.realm.delete(fixture[0])
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
    
    
    func loadFixtures() {
        fixtures.removeAll()
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club1 = club.filter(predicate)
        
        let predicate1 = NSPredicate(format: "name = %@", "\((selectedSquadName)!)")
        let squad = club1[0].squads.filter(predicate1)
        
        for fixture in squad[0].fixtures {
            fixtures.append(fixture)
        }
        
        tableView.reloadData()
    }
}

