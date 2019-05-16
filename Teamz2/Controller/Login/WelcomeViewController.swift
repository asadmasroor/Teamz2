//
//  WelcomeViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 23/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UITextField!
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Welcome"

        
        if let _ = SyncUser.current {
            // We have already logged in here!
            performSegue(withIdentifier: "signedInSegue", sender: self)
         
        }
        
    
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationvc = segue.destination as! MainMenuViewController
        
        destinationvc.username = username
    }
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
            
            self.username = usernameLabel.text!
            let creds = SyncCredentials.nickname(self.username, isAdmin: true)
            
            if  validation(username: self.username) {
                ProgressHUD.show("Signing in")
                SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                    if let _ = user {
                        ProgressHUD.dismiss()
                        self!.performSegue(withIdentifier: "signedInSegue", sender: self)
                        // self?.navigationController?.pushViewController(MainMenuViewController(), animated: true)
                        
                    } else if let error = err {
                        print("This nickname already exists")
                    }
                })
            }
        
    }
    
    
    func validation(username: String) -> Bool {
        var valid = false
        let errorMessage = UIAlertController(title: "Error", message: "No username entered", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            errorMessage.dismiss(animated: true, completion: nil)
        }
        
        errorMessage.addAction(action)
        if (username.count == 0) {
            self.present(errorMessage, animated: true, completion: nil)
        } else if (username.count > 15) {
            self.present(errorMessage, animated: true, completion: nil)
            errorMessage.message = "Username too long"
        } else {
            valid = true
        }
        
        return valid
    }

   

}
