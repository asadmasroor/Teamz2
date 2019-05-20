//
//  ChallenegeAttemptsViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ChallenegeAttemptsViewController: UITableViewController {
    
    var results = List<Result>()
    var userResults = List<Result>()
    let result: Results<Result>
    let realm : Realm
    var selectedChallengeName: String?
    
    // intialiser
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
        let predicate = NSPredicate(format: "user.owner = %@", "\((SyncUser.current?.identity)!)")
        self.result = realm.objects(Result.self).filter(predicate)
        
        super.init(nibName: nil, bundle: nil)
    }
    //intialiser
    required init?(coder aDecoder: NSCoder) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        
        let predicate = NSPredicate(format: "user.owner = %@", "\((SyncUser.current?.identity)!)")
        self.result = realm.objects(Result.self).filter(predicate)
        super.init(coder: aDecoder)
    }
    
    
    

    //function that executes when the tableviewcontroller loads
    override func viewDidLoad() {
        super.viewDidLoad()
        for resul in result {
            userResults.append(resul)
        }
        
        self.title = "Attempts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))

        
    }
    
    //function to take user to the main screen
    @objc func home(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    // function to convert seconds to minutes,hours,and seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    // MARK: - TableView Methods

    //Methods to populate the table with data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return userResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        
        
        let result = userResults[indexPath.row]
        
        let resultNo = indexPath.row + 1
        
        let minutes = secondsToHoursMinutesSeconds(seconds: Int((result.details?.duration)!))
        
        cell.textLabel?.text = "\(resultNo)) Attempt: \(minutes.0):\(minutes.1):\(minutes.2)"
        

        return cell
    }
 

   

}
