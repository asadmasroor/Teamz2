//
//  SelectionViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionViewController: UITableViewController {
    
    
    var availablePlayers = List<User>()
    var selectedPlayers = List<User>()
    
    var selectedFixture : Fixture? {
        didSet{
           
            availablePlayers = (selectedFixture?.availablePlayers)!
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath)
        
        cell.textLabel?.text = availablePlayers[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
}
