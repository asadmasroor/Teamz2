//
//  MainMenuViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class MainMenuViewController: UIViewController {
   
    let realm: Realm
    
    var UserLoggedIn : User?
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var username : String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.navigationItem.setHidesBackButton(true, animated:true);
     
    }
    

    @IBAction func myClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "clubSegue", sender: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "clubSegue") {
        let destinationVC = segue.destination as! ClubViewController
        
            
        }
        
        if (segue.identifier == "joinedClubSegue") {
            let destinationVC = segue.destination as! JoinedClubViewController
            
            //destinationVC.selectedUser = UserLoggedIn
            
        }
        
        if (segue.identifier == "searchSegue") {
            let destinationVC = segue.destination as! SearchViewController
            
            destinationVC.userLoggedIn = UserLoggedIn
            
            
        }
        
        if (segue.identifier == "selectionSegue") {
            let destinationVC = segue.destination as! PlayerSelectionViewController
            
            destinationVC.userLoggedIn = UserLoggedIn
            
            
        }
        
        if (segue.identifier == "challenege1Segue") {
            let destinationVC = segue.destination as! JoinedChallengesViewController
            
       //    destinationVC.userLoggedIn = UserLoggedIn
            
            
        }
    }
    
    
    @IBAction func newClubButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let newClubAlert = UIAlertController(title: "Make New Club", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let newClub = Club()
            newClub.name = (textField.text)!
            
            let predicate = NSPredicate(format: "owner = %@", "\((SyncUser.current?.identity)!)")
            let user = self.realm.objects(User.self).filter(predicate)
            
             try! self.realm.write {
            
        
             self.realm.add(newClub)
             user[0].clubs.append(newClub)
             user[0].joinedClubs.append(newClub)
            
            }
            
            self.performSegue(withIdentifier: "clubSegue", sender: self)
            
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
    
    
    
    @IBAction func joinedClubsButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "joinedClubSegue", sender: self)
    }
    
   
    
    
    @IBAction func joinNewClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "searchSegue", sender: self)
        
    }
    
    
    @IBAction func selectionsButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "selectionSegue", sender: self)
        
    }
    
    
    
    @IBAction func challenegeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "challenege1Segue", sender: self)
    }
    
    
    
    
    
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
    
}
