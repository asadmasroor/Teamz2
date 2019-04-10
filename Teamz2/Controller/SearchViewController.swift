//
//  SearchViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UITableViewController, SearchClubDelegate {
    
    var indexpath = 0
    
    let realm = try! Realm()
    
    var userLoggedIn : User?
    
   
    
    
    var allClubNames : [String] = []
    var joinedClubNames : [String] = []
    var notJoinedClubNames : [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    let allClubsResult = realm.objects(Club.self)
   
        for club in allClubsResult {
            
            allClubNames.append("\(club.name)")

        }
        
        
        for club in ((userLoggedIn?.joinedClubs)!) {

            joinedClubNames.append("\(club.name)")
        }
        
        
        for club in allClubNames {
            if joinedClubNames.contains(club){
                print("\(club) joined")
            } else {
                print("\(club) not joined")
                notJoinedClubNames.append(club)
            }
        }
        
    }

    func joinButtonPressed(cell: SearchTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        indexpath = indexPath!.row
        
        let predicate = NSPredicate(format: "name = %@", "\(notJoinedClubNames[indexpath])")
        
        
        let club = realm.objects(Club.self).filter(predicate)
        
        print(club[0].name)
        
        try! realm.write {
            userLoggedIn?.joinedClubs.append(club[0])
        }

        
        
            }
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notJoinedClubNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notJoinedClubCell", for: indexPath) as! SearchTableViewCell
        
        

        cell.nameLabel.text = notJoinedClubNames[indexPath.row]
        cell.descLabel.text = "Amatuer Sports Club"
        
        cell.delegate = self
        return cell
    }


    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 210
        tableView.rowHeight = UITableView.automaticDimension
        
    }

    

 

    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }


}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

//        joinedClubNames = joinedClubNames.filter("title CONTAINS[cd] %@", searchBar.text)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {


            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

        }
    }
    
}
