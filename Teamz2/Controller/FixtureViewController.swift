//
//  FixtureViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class FixtureViewController: UITableViewController, cellDelegateChallenge {
    
    
    
    
    
    
    // Global variable to store the indexpath of the table
    var uIndexPath = 0
    
    // Store fixtures of the current club's squad
    var fixtures = List<Fixture>()
    
    var selectedSquad : Squad? {
        didSet {
            fixtures = (selectedSquad?.fixtures)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fixtures.count
    }
    
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! FixtureTableViewCell
        
        let fixture = fixtures[indexPath.row]
        
        cell.setFixture(fixture: fixture)
        cell.delegate = self

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "challengeSegue") {
            let destinationVC = segue.destination as! ChallengeViewController
            
            destinationVC.selectedFixture = fixtures[uIndexPath]
            
        }
        
        if (segue.identifier == "selectionSegue") {
            let destinationVC = segue.destination as! SelectionViewController
            
            destinationVC.selectedFixture = fixtures[uIndexPath]
            
        }
        
        
        
    }
    
 
    func challengeButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "challengeSegue", sender: self)
    }
    
    
    
    func selectionButtonPressed(cell: FixtureTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        uIndexPath = indexPath!.row
        
        print(indexPath!.row)
        performSegue(withIdentifier: "selectionSegue", sender: self)
    }

    
    
}

