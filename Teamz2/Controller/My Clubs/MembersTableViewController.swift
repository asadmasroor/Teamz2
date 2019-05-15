//
//  MembersTableViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class MembersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
<<<<<<< HEAD
        
        self.tabBarController?.navigationItem.title = "Members"
        loadMembers()
        
        notificationToken = allClubs.observe { [weak self] (changes) in
          
            switch changes {
            case .initial:
                self?.loadMembers()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self?.loadMembers()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
=======
>>>>>>> parent of 2c732df... remove members done

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

=======

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

>>>>>>> parent of 2c732df... remove members done
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

<<<<<<< HEAD
<<<<<<< HEAD
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Members"
=======
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
>>>>>>> parent of 2c732df... remove members done
=======
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
>>>>>>> parent of 2c732df... remove members done
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
<<<<<<< HEAD
<<<<<<< HEAD
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            
            let confirmation = UIAlertController(title: "Remove \(self.clubMembers![indexPath.row].username)?", message: "Are you sure you want to remove \(self.clubMembers![indexPath.row].username) from \(self.selectedClubName!)?", preferredStyle: .alert)
            
            
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                
                
                let predicate1 = NSPredicate(format: "username == %@", "\(self.clubMembers![indexPath.row].username)")
                let user = self.realm.objects(User.self).filter(predicate1)
                
                //Deleting club from user joined club list
                for (index, club) in user[0].joinedClubs.enumerated() {
                    if club.name == self.selectedClubName! {
                        try! self.realm.write {
                            print("hiiiii 22")
                            user[0].joinedClubs.remove(at: index)
                            //self.realm.delete(self.UserLoggedIn[0].joinedClubs[index])
                        }
                        break
                    }
                }
                
                
                let predicate = NSPredicate(format: "name == %@", "\(self.selectedClubName!)")
                let club1 = self.realm.objects(Club.self).filter(predicate)
                
                for (index, user) in club1[0].members.enumerated() {
                    if user.username ==  self.clubMembers?[index].username {
                        try! self.realm.write {
                            print("hiiiii")
                            club1[0].members.remove(at: index)
                            
                            //self.realm.delete(club1[0].members[index])
                        }
                        break
                    }
                }
                
                
                
          
            
                
                self.loadMembers()
                
               
            })
            
            
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (UIAlertAction) in
                confirmation.dismiss(animated: true, completion: nil)
            }
            
            confirmation.addAction(yesAction)
            confirmation.addAction(cancelAction)
            
            self.present(confirmation, animated: true, completion: nil)
            
        }
        
        return [deleteAction]
    }
    
=======
    */
>>>>>>> parent of 2c732df... remove members done
=======
    */
>>>>>>> parent of 2c732df... remove members done

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
<<<<<<< HEAD
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
=======
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
>>>>>>> parent of 2c732df... remove members done

}
