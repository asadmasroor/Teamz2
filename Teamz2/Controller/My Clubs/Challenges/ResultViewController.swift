//
//  ResultViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UITableViewController {
    
    let realm: Realm
    
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
    
    var results = List<Result>()
    var selectedClubName : String?
    var selectedChallengeName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadResults()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (results.count == 0 ){
            return 1
        } else {
             return results.count
        }
       
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultsTableViewCell
        
        
        if (results.count != 0 ) {
            
            let name = results[indexPath.row].user?.username
            
            let minutes = results[indexPath.row].details?.duration
            
            cell.resultLabel.text = "\(name): \(minutes) seconds"
            
        } else {
           cell.resultLabel.text = "No Results Yet!"
        }
    
    
        return cell
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func loadResults() {
        
        if selectedClubName != nil && selectedChallengeName != nil {
            
            let predicate = NSPredicate(format: "name = %@", "\((selectedClubName)!)")
            let club = realm.objects(Club.self).filter(predicate)
            
            if club.count != 0 {
                let predicate1 = NSPredicate(format: "name = %@", "\((selectedChallengeName)!)")
                let challenge = club[0].challenges.filter(predicate1)
                
                if challenge.count != 0 {
                    self.title = "\((challenge[0].name)) results"
                    let result1 = challenge[0].results
                    
                    for r in result1 {
                        results.append(r)
                    }
                }
            }
            
            
        }
    }

}


