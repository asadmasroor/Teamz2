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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AttemptChallengeController
        print(challenges[iPath].name)
        destinationVC.selectedChallenge = challenges[iPath]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
