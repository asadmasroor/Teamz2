//
//  JoinedChallengesViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class JoinedChallengesViewController: UITableViewController, joinedChallengeDelegate  {
   
    var iPath = 0
    
    var challenges = List<Challenge>()
    
    
    var selectedFixture : Fixture? {
        didSet {
            challenges = (selectedFixture?.challenges)!
        }
    }
    
    var userLoggedIn : User? 

    override func viewDidLoad() {
        super.viewDidLoad()

        print(challenges.count)
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return challenges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedChallengeCell", for: indexPath) as! JoinedChallengeViewCell
        
        let challenge = challenges[indexPath.row]
        cell.delegate = self

        cell.setChallenge(challenge: challenge)
        

        return cell
    }
 
    func attemptChallenegeButtonPressed(cell: JoinedChallengeViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        
        
        performSegue(withIdentifier: "attemptChallenegeSegue", sender: self)
    }
    
    func viewAttemptsButtonPressed(cell: JoinedChallengeViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        iPath = indexPath!.row
        performSegue(withIdentifier: "viewAttemptSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "attemptChallenegeSegue") {
            let destinationVC = segue.destination as! AttemptChallengeController
            
            destinationVC.selectedChallenge = challenges[iPath]
            destinationVC.userLoggedIn = userLoggedIn
        }
        
        if (segue.identifier == "viewAttemptSegue") {
            let destinationVC = segue.destination as! ChallenegeAttemptsViewController
            destinationVC.userLoggedIn = userLoggedIn
            destinationVC.selectedChallenge = selectedFixture?.challenges[iPath]
            
        }
        
        
    }
    
    

    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    

}
