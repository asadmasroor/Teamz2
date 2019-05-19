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
import Validation
import Log

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UITextField!
    var username: String = ""
    let Log = Logger()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       usernameLabel.delegate = self
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
    
    
    @IBAction @objc func goButtonPressed(_ sender: Any) {
        
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        var validation = Validation()
        validation.characterSet = NSCharacterSet.letters
        validation.minimumLength = 1
        validation.maximumLength = 20
        
        var validation2 = Validation()
        validation.characterSet = NSCharacterSet.lowercaseLetters
       
        
        
            
            self.username = usernameLabel.text!
            let creds = SyncCredentials.nickname(self.username, isAdmin: true)
            
        
                if validation.validateString(self.username) && validation2.validateString(self.username) {
                    
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

                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "Please only use lowercase letters between 1 to 20 with no symbols.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        Log.info("Time elapsed for sign in: \(timeElapsed) s.")
       
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let startTime = CFAbsoluteTimeGetCurrent()
        var validation = Validation()
        validation.characterSet = NSCharacterSet.lowercaseLetters
        validation.minimumLength = 1
        validation.maximumLength = 20
        
        textField.resignFirstResponder() // Dismiss the keyboard
        self.username = usernameLabel.text!
        let creds = SyncCredentials.nickname(self.username, isAdmin: true)
        
        
            if validation.validateString(self.username) {
                
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
            } else {
                let alert = UIAlertController(title: "Error", message: "Please only use lowercase letters between 1 to 20.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
       Log.info("Time elapsed for sign in: \(timeElapsed) s.")
        return true
        
    }
    
    
 

   

}
