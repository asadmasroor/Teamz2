//
//  requestsTableViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class requestsTableViewController: UITableViewController, requestTableViewDelegate {
    
    let realm: Realm
    var selectedClubName : String?
    let club: Results<Club>
    var requests : List<User>?
    var notificationToken: NotificationToken?
    var uIndexPath = 0
    
    // intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)

        self.club = realm.objects(Club.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
        self.club = realm.objects(Club.self)
        super.init(coder: aDecoder)
    }
    
    //function that excutes when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.title = "Requests"
        
        loadRequests()
        
        notificationToken = club.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.loadRequests()

            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
    

    }

    //function that excutes when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
    
        self.tabBarController?.navigationItem.rightBarButtonItems = [homeButton]
    }
    
    // function that excutes once the view has appeared.
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Requests"
    }
    
    // function to take user back to the main screen
    @objc func home() {
        navigationController?.popToRootViewController(animated: true)
        
    }


    // MARK: - Table view data source
    
    // functions to populate table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! requestsTableViewCell
        
        if requests?.count != 0 {
            cell.nameLabel.isHidden = false
            cell.acceptButton.isHidden = false
            cell.declineButton.isHidden = false
             cell.nameLabel.text = requests![indexPath.row].username
             cell.delegate = self
            
        } else {
//            cell.nameLabel.isHidden = true
            cell.acceptButton.isHidden = true
            cell.declineButton.isHidden = true
            cell.nameLabel?.text = "No Request's Yet"
            
            
        }
       
    
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (requests!.count != 0) {
            return true
        }
        else {
            return false
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if requests?.count != 0 {
            return (requests?.count)!
        } else {
            return 1
        }
        
    }
    
    // function that executes when accept button is pressed
    func acceptButtonPressed(cell: requestsTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        
        let oneClub = club.filter(predicate)
        
       
        
        if oneClub.count != 0 {
            print("hello")
            let user = oneClub[0].requests[(indexPath?.row)!]
            
            
            
            try! realm.write {
                user.joinedClubs.append(oneClub[0])
                oneClub[0].members.append(user)
                oneClub[0].requests.remove(at: (indexPath?.row)!)
            }
        }
        
        loadRequests()
        
        
    }
    
    // function that exccutes when decline button is pressed
    func declineButtonPressed(cell: requestsTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        
        let oneClub = club.filter(predicate)
        
        if oneClub.count != 0 {
            try! realm.write {
                oneClub[0].requests.remove(at: (indexPath?.row)!)
            }
        }
        
        loadRequests()

    }
    
    
    // function to retrive requests to join club
    func loadRequests() {
        
        
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        
        let oneClub = club.filter(predicate)
        requests = oneClub[0].requests
        
        tableView.reloadData()
    }
 
    //deintialiser
    deinit {
        notificationToken?.invalidate()
    }

}
