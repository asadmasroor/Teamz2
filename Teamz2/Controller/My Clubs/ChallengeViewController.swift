//
//  ChallengeViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ChallengeViewController: UITableViewController {
    
    let realm: Realm
    var dIndexPath = 0
    var challanges = List<Challenge>()
    
    
    var selectedClubName : String?
    var userLoggedIn : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChalleneges()
       
    }
    
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

    // MARK: - Table view data source

   
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return challanges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell

        let challenge = challanges[indexPath.row]
        
        cell.setChallenege(challenge: challenge)
        
        cell.delegate = self

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        self.tabBarController?.navigationItem.title = "Challeneges"
        
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewChallenge))
        self.tabBarController?.navigationItem.rightBarButtonItems = [addBarButton, homeButton]
        
       loadChalleneges()
    }
    
    
    @objc func home() {
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func addNewChallenge() {
        
       
        performSegue(withIdentifier: "makeChallengeSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Delete?", message: "Are you sure you want to delete \(self.challanges[indexPath.row].name)?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                
                print(self.challanges[indexPath.row].name)
                
                //let predicate = NSPredicate(format: "name = &@", "\(self.challanges[indexPath.row].name)")
                let predicate = NSPredicate(format: "name = %@", "\(self.challanges[indexPath.row].name)")
                let challenege1 = self.realm.objects(Challenge.self).filter(predicate)
                try! self.realm.write {

                    if challenege1.count != 0 {
                        self.challanges.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        self.realm.delete(challenege1[0])
                        self.loadChalleneges()
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
    

    
 

}

extension ChallengeViewController: cellDelegateResult {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "resultSegue" {
            
            let destinationVC = segue.destination as! ResultViewController
            
            destinationVC.selectedChallenge = challanges[dIndexPath]
            
        }
        
        
        if segue.identifier == "makeChallengeSegue" {
            
            let destinationVC = segue.destination as! makeChallenegeController
            
            destinationVC.SelectedClubName = selectedClubName
            
        }
            
        
    }
    
    func resultButtonPressed(cell: ChallengeTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        dIndexPath = indexPath!.row
        print("dindexpath: \(dIndexPath)")
        performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    func loadChalleneges() {
        
        print("hello this loadchallenges with \(selectedClubName!)")
        
        let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
        let club = realm.objects(Club.self).filter(predicate)
        
        print(club.count)
        
        if club.count != 0 {
            challanges.removeAll()
            
           
            let challenges1 = club[0].challenges
            
            for x in challenges1 {
                challanges.append(x)
            }
            
        }

        
        tableView.reloadData()
    }
    
    
    
}
