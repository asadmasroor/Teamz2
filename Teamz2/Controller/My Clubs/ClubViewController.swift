//
//  ClubViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
class ClubViewController: UITableViewController {
    
    var clubs = List<Club>()
    
    var selectedUser : User? {
        didSet {
            clubs = (selectedUser?.clubs)!
        }
    }
    
    
   
    
    var indexPath1 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return clubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell", for: indexPath) as! ClubTableViewCell
        
        cell.clubLabel.text = clubs[indexPath.row].name
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "squadchallenegeSegue") {
            let barViewControllers = segue.destination as! SquadChallenegeTab
            let destinationViewController = barViewControllers.viewControllers?[0] as! SquadViewController
            destinationViewController.UserLoggedIn = selectedUser
            destinationViewController.selectedClub = clubs[indexPath1]
            
            let destinationViewController1 = barViewControllers.viewControllers?[1] as! ChallengeViewController
            
            destinationViewController1.userLoggedIn = selectedUser
            destinationViewController1.selectedClub = clubs[indexPath1]
            
            print(clubs[indexPath1].name)
            
        }
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = indexPath.row
        
        performSegue(withIdentifier: "squadchallenegeSegue", sender: self)
        
        
        
    }
    


}
