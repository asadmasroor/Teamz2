//
//  ChallengeViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class ChallengeViewController: UITableViewController {
    
    var dIndexPath = 0
    var challanges = List<Challenge>()
    var selectedFixture : Fixture? {
        didSet{
            print(selectedFixture?.title)
           
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

   
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return challanges.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell

        let challenge = challanges[indexPath.row]
        
        cell.setChallenege(challenge: challenge)
        
        cell.delegate = self

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        var descField = UITextField()
        var mileField = UITextField()
        let newChallengeAlert = UIAlertController(title: "Add New Challenge", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let newChallenge = Challenge()
            newChallenge.name = (textField.text)!
            newChallenge.desc = (descField.text)!
            newChallenge.miles = Int((mileField.text)!)!
            
            self.challanges.append(newChallenge)
            
            self.tableView.reloadData()
            
            
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            newChallengeAlert.dismiss(animated: true, completion: nil)
        }
        
        newChallengeAlert.addTextField { (UITextField) in
            UITextField.placeholder = "Enter name for Challenge"
            textField = UITextField
        }
        
        newChallengeAlert.addTextField { (UIDescriptionTextField) in
            UIDescriptionTextField.placeholder = "Enter description for Challenge Name"
            descField = UIDescriptionTextField
        }
        
        newChallengeAlert.addTextField { (UIMilesTextField) in
            UIMilesTextField.placeholder = "Enter miles for Challenge"
            mileField = UIMilesTextField
        }
        
        
        
        newChallengeAlert.addAction(action)
        newChallengeAlert.addAction(cancelAction)
        
        present(newChallengeAlert, animated: true, completion: nil)
    }
    
 

}

extension ChallengeViewController: cellDelegateResult {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            let destinationVC = segue.destination as! ResultViewController
            
            destinationVC.selectedChallenge = challanges[dIndexPath]
            
        
    }
    
    func resultButtonPressed(cell: ChallengeTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        dIndexPath = indexPath!.row
        print("dindexpath: \(dIndexPath)")
        performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    
    
    
    
}
