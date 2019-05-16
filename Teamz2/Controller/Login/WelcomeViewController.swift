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
    
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Welcome"
        
        let query = RealmQuery()
        
        query.loginUser(username: username)
        
        if let _ = SyncUser.current {
            // We have already logged in here!
            performSegue(withIdentifier: "signedInSegue", sender: self)
          //  self.navigationController?.pushViewController(MainMenuViewController(), animated: true)
        } else {
            
            let alertController = UIAlertController(title: "Login/Sign Up", message: "Supply a username", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Go!", style: .default, handler: { [unowned self]
                alert -> Void in
                
                ProgressHUD.show("Signing in")
                let textField = alertController.textFields![0] as UITextField
                let creds = SyncCredentials.nickname(textField.text!, isAdmin: true)
                self.username = textField.text!
                
                SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                    if let _ = user {
                        ProgressHUD.dismiss()
                        self!.performSegue(withIdentifier: "signedInSegue", sender: self)
                       // self?.navigationController?.pushViewController(MainMenuViewController(), animated: true)
                        
                    } else if let error = err {
                        print("This nickname already exists")
                    }
                })
            }))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "A Name for your user"
            })
            self.present(alertController, animated: true, completion: nil)
        }
        
    
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationvc = segue.destination as! MainMenuViewController
        
        destinationvc.username = username
    }
    

   

}
