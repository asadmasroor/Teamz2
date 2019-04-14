//
//  PlayerSelectionViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 11/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerSelectionViewController: UITableViewController, playerSelectionDelegate {
  
    var userLoggedIn : User?
    let realm = try! Realm()
    
    var fixtures: Results<Fixture>? = nil
    var selectedFixtures = List<Fixture>()
   
    var publishedSquad = List<Confirmation>()
   
    
    var stringUser : [String] = []
     var number : [Int] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
       loadSelectedFixtures()
    
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((selectedFixtures.count)) != 0{
            return (selectedFixtures.count)
        } else {
            return 1
        }
       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! PlayerSelectionViewCell

        
        if selectedFixtures.count != 0  {
            let fixture1 = selectedFixtures[indexPath.row]
            
            let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath.row].title)")
            let fixture = realm.objects(Fixture.self).filter(predicate)
            
            let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
            let user = fixture[0].publishedSquad.filter(predicate1)
            
            if user[0].available == true {
                cell.backgroundColor = UIColor(red:0.22, green:0.75, blue:0.19, alpha:1.0)
            } else if (user[0].available == false) {
            cell.backgroundColor = UIColor(red:0.26, green:0.54, blue:0.98, alpha:1.0)
            }
            
            cell.titleLabel.text = fixture1.title
            cell.addressLabel.text =  fixture1.address
        } else {
            cell.titleLabel.isHidden = true
            cell.addressLabel.isHidden = true
            cell.textLabel?.text = "You have not been selected yet."
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor(red:0.00, green:0.51, blue:1.00, alpha:1.0)
            cell.confirmButton.isHidden = true
            cell.declineButton.isHidden = true
           self.tableView.rowHeight = 50
            
            
        }
        
        
       
        
        cell.delegate = self

        return cell
    }
    
    
    func loadSelectedFixtures() {
        
        selectedFixtures.removeAll()
        
        let fixtures = realm.objects(Fixture.self)
        
        for fixture in fixtures {
            
            
            publishedSquad = fixture.publishedSquad
            
            for user in publishedSquad {
                if user.user?.username ==  userLoggedIn?.username {
                    selectedFixtures.append(fixture)
                }
            }
            
        }
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    
    func confirmButtonPressed(cell: PlayerSelectionViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        

        let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath!.row].title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
        let user = fixture[0].publishedSquad.filter(predicate1)
        
        
        print(fixture[0].title)
         try! realm.write {
            
            user[0].available = true
            
            
           self.tableView.reloadData()

        }
        
        
      
        
    }
    
    func declineButtonPressed(cell: PlayerSelectionViewCell) {
        
        let declineAlert = UIAlertController(title: "Decline selection for this fixture?", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            let indexPath = self.tableView.indexPath(for: cell)
            
            
            let predicate = NSPredicate(format: "title = %@", "\(self.selectedFixtures[indexPath!.row].title)")
            let fixture = self.realm.objects(Fixture.self).filter(predicate)
            
            let predicate1 = NSPredicate(format: "user.username = %@", "\(self.userLoggedIn!.username)")
            //let user = fixture[0].publishedSquad.filter(predicate1)
            
            
            let confirmations = self.realm.objects(Confirmation.self)
            
            
            try! self.realm.write {
                
                self.tableView.reloadData()
                
                var count = -1
                for confirmation in confirmations {
                    count += 1
                    if ((confirmation.user?.username == (self.userLoggedIn?.username)!) && (confirmation.fixture?.title == self.selectedFixtures[indexPath!.row].title)){
                        self.realm.delete(confirmations[count])
                    }
                }
                self.loadSelectedFixtures()
                self.tableView.reloadData()
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            declineAlert.dismiss(animated: true, completion: nil)
        }
        
        
        declineAlert.addAction(yesAction)
        declineAlert.addAction(cancelAction)
        
        present(declineAlert, animated: true, completion: nil)
        
        
    }

}
