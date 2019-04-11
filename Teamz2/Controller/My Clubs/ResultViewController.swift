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
            
            results = (selectedChallenge?.results)!
            
              self.title = "\((selectedChallenge?.name)!)"
            
           
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (results.count == 0 ){
            return 1
        } else {
             return results.count
        }
       
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultsTableViewCell
        
        
        if (results.count != 0 ) {
            
            let name = (selectedChallenge?.results[indexPath.row].user?.name)!
            let minutes = (selectedChallenge?.results[indexPath.row].details?.duration)!
            
            
            cell.resultLabel.text = "\(name): \(minutes) seconds"
            
        } else {
           cell.resultLabel.text = "No Results Yet!"
        }
    
    
        return cell
    }

  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }



}


