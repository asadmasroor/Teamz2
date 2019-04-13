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
        
        
       
        
        let fixtures = realm.objects(Fixture.self)
        
        for fixture in fixtures {
            
            
            publishedSquad = fixture.publishedSquad
            
            for user in publishedSquad {
                if user.user?.username ==  userLoggedIn?.username {
                    selectedFixtures.append(fixture)
                }
            }
           
        }
        
        print(selectedFixtures.count)
    
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((selectedFixtures.count)) != nil &&  ((selectedFixtures.count)) != 0{
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
               cell.backgroundColor = UIColor(red:0.73, green:0.04, blue:0.16, alpha:1.0)
            }
            
            cell.titleLabel.text = fixture1.title
            cell.addressLabel.text =  fixture1.address
        } else {
            cell.titleLabel.text = "You have not been selected yet"
            cell.addressLabel.text = ""
            cell.confirmButton.isHidden = true
            cell.declineButton.isHidden = true
            
        }
        
        
       
        
        cell.delegate = self

        return cell
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
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        
        let predicate = NSPredicate(format: "title = %@", "\(selectedFixtures[indexPath!.row].title)")
        let fixture = realm.objects(Fixture.self).filter(predicate)
        
        let predicate1 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
        let user = fixture[0].publishedSquad.filter(predicate1)
        
        let ps = fixture[0].publishedSquad
        
        
        let predicate2 = NSPredicate(format: "user.username = %@", "\(userLoggedIn!.username)")
        let confirmation = realm.objects(Confirmation.self).filter(predicate2)
        
        if confirmation[0].parentFixture[0].title == selectedFixtures[indexPath!.row].title {
            
            try! realm.write {
                
                user[0].available = false
                var count = -1
                for user in ps {
                    count += 1
                    if user.user?.username == userLoggedIn?.username {
                        
                        realm.delete(confirmation)
                        selectedFixtures.remove(at: count)
                    }
                    
                }
                
                
                self.tableView.reloadData()
                
                
                
            }
            
        }
        
        
        
        
    }

}
