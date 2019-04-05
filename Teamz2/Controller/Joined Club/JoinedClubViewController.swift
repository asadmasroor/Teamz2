//
//  JoinedClubViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class JoinedClubViewController: UITableViewController {
    
    var indexpath1 = 0
    
    var joinedClubs = List<Club>()
    
    var selectedUser : User? {
        didSet {
            joinedClubs = (selectedUser?.joinedClubs)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return joinedClubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedclubCell", for: indexPath) as! JoinedClubTableViewCell
        
        cell.clubLabel.text = joinedClubs[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desitinationVC =  segue.destination as! JoinedSquadViewController
        
        desitinationVC.selectedClub = joinedClubs[indexpath1]
        desitinationVC.userLoggedIn = selectedUser
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexpath1 = indexPath.row
        performSegue(withIdentifier: "joinedSquadSegue", sender: nil)
    }

}
