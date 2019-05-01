//
//  SelectionViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionViewController: UITableViewController {
    
    let realm: Realm
    
    var availablePlayers = List<Available>()
    
    
    var availablePLayersName : [String] = []
    var selectedClubName : String?
    var selectedSquadName : String?
    var selectedFixtureName : String?
    
    let allClubs : Results<Club>
    let allAvailbility : Results<Available>
    var club : Results<Club>? = nil
    var squad : Results<Squad>? = nil
    var fixture : Results<Fixture>? = nil
    
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
        self.allClubs = realm.objects(Club.self)
        
        self.allAvailbility = realm.objects(Available.self)
       

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
        self.allClubs = realm.objects(Club.self)
        self.allAvailbility = realm.objects(Available.self)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
       
        loadAvailablePlayers()
        
        notificationToken = allAvailbility.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadAvailablePlayers()
                
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
        
        cell.playerNameLabel.text = availablePlayers[indexPath.row].user?.username
        
        if(availablePlayers[indexPath.row].isSelected == true){
            cell.accessoryType = .checkmark
        } else {
             cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((availablePlayers[indexPath.row].user?.username)!)
        let predicate0 = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club = realm.objects(Club.self).filter(predicate0)
        
        let predicate1 = NSPredicate(format: "name = %@", "\((selectedSquadName)!)")
        let squad = club[0].squads.filter(predicate1)
        
        let predicate = NSPredicate(format: "title = %@", "\((selectedFixtureName)!)")
        let fixture = squad[0].fixtures.filter(predicate)
        
     
        let user = fixture[0].availablePlayers[indexPath.row]
        
        if (availablePlayers[indexPath.row].isSelected == true) {
            try! realm.write {
               user.isSelected = false
            }
        } else if (availablePlayers[indexPath.row].isSelected == false) {
            try! realm.write {
              user.isSelected = true
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadData()
    }
    
    
 
    @IBAction func publishButtonPressed(_ sender: Any) {
        
    
        let confirmations = self.realm.objects(Confirmation.self)

        let predicate = NSPredicate(format: "fixture.title = %@", "\((fixture![0].title))")

        let deleteConfirmations = confirmations.filter(predicate)
        
        
        
        deleteConfirmationObject(confirmation: deleteConfirmations)
        
        if availablePlayers.count != 0 {
            for user in availablePlayers{
                if user.isSelected == true {
                    
                    let confirmation = Confirmation()
                    confirmation.user = user.user
                    confirmation.fixture = fixture![0]
                    try! realm.write {
                        
                        realm.add(confirmation)
                        fixture![0].publishedSquad.append(confirmation)
                    }
                }
            }
        }
        
        

//        if fixture![0].publishedSquad.count == 0 {
//            try! realm.write {
//                fixture![0].publishedSquad.removeAll()
//                realm.delete(deleteConfirmations)
//            }
//
//        }
//
//        else if (fixture![0].publishedSquad.count != 0) {
//            try! realm.write {
//                fixture![0].publishedSquad.removeAll()
//            }
//
//            for user in availablePlayers{
//                if user.isSelected == true {
//
//                    let confirmation = Confirmation()
//                    confirmation.user = user.user
//                    confirmation.fixture = fixture![0]
//                    try! realm.write {
//
//                        realm.add(confirmation)
//                        fixture![0].publishedSquad.append(confirmation)
//                    }
//                }
//            }
//
//        }

        let alertController = UIAlertController(title: "Squad Published", message: "", preferredStyle: .alert)

        let ok = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(ok)

        present(alertController, animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 1
        
        }
        
    
        
    
    
    
    func loadAvailablePlayers() {
        
        
       
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        club = realm.objects(Club.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "name = %@", "\((selectedSquadName)!)")
        squad = club![0].squads.filter(predicate1)
        
        let predicate2 = NSPredicate(format: "title = %@", "\((selectedFixtureName)!)")
        fixture = squad![0].fixtures.filter(predicate2)
        
        
        
        availablePlayers = fixture![0].availablePlayers
        
        tableView.reloadData()
    }
    
    func deleteConfirmationObject(confirmation: Results<Confirmation>) {
        
        try! realm.write {
            realm.delete(confirmation)
        }
    }
    
    
}
