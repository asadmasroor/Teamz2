//
//  ResultViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UITableViewController {
    
    
    
    var results = List<Result>()
    var selectedChallenge : Challenge? {
        didSet{
            print((selectedChallenge?.name)!)
            results = (selectedChallenge?.results)!
            
            print((selectedChallenge?.results[2].user?.name)!)
            
           
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        let name = (selectedChallenge?.results[indexPath.row].user?.name)!
        let minutes = (results[indexPath.row].timeTaken)
        
        
        cell.textLabel?.text = "\(name): \(minutes) minutes"
        
        return cell
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }



}


