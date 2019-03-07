//
//  SquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SquadViewController: UITableViewController {
    
    var squads = List<Squad>()
    var findexPath = 0
    
    var selectedClub : Club? {
        didSet {
            squads = (selectedClub?.squads)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            initialiseData()
    }

    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return squads.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "squadCell", for: indexPath)
        
        cell.textLabel?.text = self.squads[indexPath.row].name
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FixtureViewController
        
        destinationVC.selectedSquad = squads[findexPath]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        findexPath = indexPath.row
        
        performSegue(withIdentifier: "fixtureSegue", sender: self)
        
    }
 
    
}
