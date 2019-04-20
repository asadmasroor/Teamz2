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
   
    
    let realm = try! Realm()
    @IBOutlet weak var welcomeLabel: UILabel!
    var UserLoggedIn : User?
    override func viewDidLoad() {
        super.viewDidLoad()
    //initialiseData()
//        let user = realm.objects(User.self).filter("username == 'asadmasroor'")
//        UserLoggedIn =  user[0]
        welcomeLabel.text = "Welcome \((UserLoggedIn!.name))"

        // Do any additional setup after loading the view.
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    @IBAction func myClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "clubSegue", sender: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "clubSegue") {
        let destinationVC = segue.destination as! ClubViewController
        
        destinationVC.selectedUser = UserLoggedIn
            
        }
        
        if (segue.identifier == "joinedClubSegue") {
            let destinationVC = segue.destination as! JoinedClubViewController
            
            destinationVC.selectedUser = UserLoggedIn
            
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
            
            destinationVC.userLoggedIn = UserLoggedIn
            
            
        }
    }
    
    
    @IBAction func newClubButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let newClubAlert = UIAlertController(title: "Make New Club", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
             try! self.realm.write {
             let newClub = Club()
             newClub.name = (textField.text)!
                self.UserLoggedIn!.clubs.append(newClub)
             self.UserLoggedIn!.joinedClubs.append(newClub)
             self.realm.add(newClub)
            
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
    }
    
}
