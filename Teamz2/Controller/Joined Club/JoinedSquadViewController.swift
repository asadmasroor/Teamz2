//
//  JoinedSquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
class JoinedSquadViewController: UITableViewController {
    
    var indexPath1 = 0
    
    var squads = List<Squad>()
    
    
    var selectedClub : Club? {
        didSet {
            squads = (selectedClub?.squads)!
        }
    }
    
    var userLoggedIn : User? 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return squads.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "squadCell", for: indexPath) as! JoinedSquadTableViewCell

        cell.squadLabel.text = squads[indexPath.row].name

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JoinedFixturesViewController
        
        destinationVC.selectedSquad = squads[indexPath1]
        destinationVC.userLoggedIn = userLoggedIn
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = indexPath.row
        
        performSegue(withIdentifier: "joinedFixtureSegue", sender: self)
    }


}
