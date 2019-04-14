//
//  PublishedSquadViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 14/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class PublishedSquadViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var userLoggedIn : User?
    var selectedFixture: Fixture?
    
    var selectedPlayers = List<Confirmation>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let predicate = NSPredicate(format: "title = %@", "\((selectedFixture?.title)!)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        print(fixture.count)
        
        
        if fixture.count != 0 {
            
            let predicate1 = NSPredicate(format: "available = true")
            let publishedSquad = fixture[0].publishedSquad
            
            for players in publishedSquad {
                selectedPlayers.append(players)
            }

        
        
    }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPlayers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publishedCell", for: indexPath) as! PublishedSquadTableViewCell
        
        let player = selectedPlayers[indexPath.row]

        
        
        if player.available == true {
             cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
            cell.nameLabel?.text = ("\((player.user?.name)!): Confirmed")
            
        } else if player.available == false {
            cell.backgroundColor = UIColor(red:0.26, green:0.54, blue:0.98, alpha:1.0)
            cell.nameLabel?.text = ("\((player.user?.name)!): Awaiting Confirmation")
        }

        return cell
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
