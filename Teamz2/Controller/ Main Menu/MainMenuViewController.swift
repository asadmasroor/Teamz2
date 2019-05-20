//
//  MainMenuViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
import Validation
import Log
class MainMenuViewController: UIViewController {
   
    let realm: Realm
    let Log = Logger()
    var UserLoggedIn : User?
    
    @IBOutlet weak var clubRequestsButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    var username : String?
    
    //Intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    
    //Intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(coder: aDecoder)
        
    }
    
    //function that execuetes when the view controller loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // load user details once the view controller loads up
      loadUser()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
     
    }

    
    // MARK: Display Alert Methods
    
    func presentOkayAlert() {
        let okayAlert = UIAlertController(title: "Club is waiting for approval", message: "", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            okayAlert.dismiss(animated: true, completion: nil)
        }
        
        okayAlert.addAction(okayAction)
        
        present(okayAlert, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let okayAlert = UIAlertController(title: "Error", message: "Please enter valid name. Between 1-30 characters.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            okayAlert.dismiss(animated: true, completion: nil)
        }
        
        okayAlert.addAction(okayAction)
        
        present(okayAlert, animated: true, completion: nil)
    }
    
    func presentClubExistsAlert(name: String) {
        let okayAlert = UIAlertController(title: "Error", message: "Club with name '\(name)' already exists!", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            okayAlert.dismiss(animated: true, completion: nil)
        }
        
        okayAlert.addAction(okayAction)
        
        present(okayAlert, animated: true, completion: nil)
    }
    
    
    // MARK:  Display Realm Methods
    
    // function to load user details from the database in realm cloud
    func loadUser() {
        let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
        let user = realm.objects(User.self).filter(predicate)
        
        
        if user.count == 0 {
            let newUser = User()
            newUser.username = "\(username!)"
            newUser.owner = (SyncUser.current?.identity)!
            welcomeLabel.text = "Welcome \(username!)"
            
            
            try! self.realm.write {
                self.realm.add(newUser)
            }
        } else {
            welcomeLabel.text = "Welcome \(user[0].username)"
            UserLoggedIn = user[0]
        }
        
        if user[0].username != "admin" {
            clubRequestsButton.isHidden = true
        } else if user[0].username == "admin" {
            clubRequestsButton.isHidden = false
        }
    }
    
    // function to add new club to the database in realm cloud
    func addNewClub(club: Club){
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        try! self.realm.write {
            
            let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
            let user = self.realm.objects(User.self).filter(predicate)
            
            self.realm.add(club)
            user[0].clubs.append(club)
            user[0].joinedClubs.append(club)
        }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        Log.info("Time elapsed for making new Club \(timeElapsed) s.")
    }
    
    
    
    // MARK: Button Pressed Methods
    
    // ADMIN ONLY: Club Request button pressed - takes to club requests view
    @IBAction func clubRequestsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "clubRequests", sender: self)
    }
    
    // SignOut Button pressed - logs user out
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            
            
            self.navigationController?.popToRootViewController(animated: true)
            //   self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
            print("Logged Out")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Challenge button pressed - takes user to challenges screen
    @IBAction func challenegeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "challenege1Segue", sender: self)
    }
    
    // Selection button pressed- takes user to selections button pressed
    @IBAction func selectionsButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "selectionSegue", sender: self)
        
    }
    
    // Joined clubs button pressed - takes user to joined clubs screen
    @IBAction func joinedClubsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "joinedClubSegue", sender: self)
    }
    
    // Join new club button pressed - takes user to join new club screen
    @IBAction func joinNewClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "searchSegue", sender: self)
        
    }
    
    // prepares join new club screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "searchSegue") {
            let destinationVC = segue.destination as! SearchViewController
            
            destinationVC.userLoggedIn = UserLoggedIn
            
        }
        
    }
    
    // New club button pressed - allows user to make a new club
    @IBAction func newClubButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let newClubAlert = UIAlertController(title: "Make New Club", message: "", preferredStyle: .alert)
        
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            var validation = Validation()
            validation.maximumLength = 30
            validation.minimumLength = 1
            
            
            
            if (validation.validateString((textField.text)!)) {
                let allClubs = self.realm.object(ofType: Club.self, forPrimaryKey: textField.text!)
                if allClubs != nil {
                    self.presentClubExistsAlert(name: (textField.text)!)
                } else {
                    let newClub = Club()
                    newClub.name = (textField.text)!
                    
                    self.addNewClub(club: newClub)
                    
                    self.presentOkayAlert()
                }
                
            } else {
                self.presentErrorAlert()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            newClubAlert.dismiss(animated: true, completion: nil)
        }
        
        newClubAlert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter name for club"
            textField = UITextField
        }
        
        newClubAlert.addAction(action)
        newClubAlert.addAction(cancelAction)
        
        present(newClubAlert, animated: true, completion: nil)
    }
    
    // my club button pressed - takes user to screen where he can see all clubs
    @IBAction func myClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "clubSegue", sender: self)
        
    }
    

    
    
}
