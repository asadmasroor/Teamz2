//
//  SignUpViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 22/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class SignUpViewController: UIViewController {
    
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func signUpButtonPressed(_ sender: Any) {
        if let _ = SyncUser.current {
            performSegue(withIdentifier: "signedUpSegue", sender: self)
            //  self.navigationController?.pushViewController(MainMenuViewController(), animated: true)
        } else {
            
           
            
            if checkInputs(username: usernameTextField, password: passwordTextField) == true {
                let creds    = SyncCredentials.usernamePassword(username: "\((usernameTextField.text)!)", password: "\((passwordTextField.text)!)", register: true)
                
                
                SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                    if let _ = user {
                        self!.performSegue(withIdentifier: "signedUpSegue", sender: self)
                    } else if let error = err {
                        print("user ALREADY exist")
                    }
                })
            } else {
                print("Fill the fields")
            }
            
            
        }
        
    }
    
    
    func checkInputs(username: UITextField, password: UITextField) -> Bool {
        
        if username.text!.count != 0 && password.text!.count != 0{
            return true
        } else {
            return false
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "signedUpSegue" {
            let dv = segue.destination as! MainMenuViewController
            dv.username = (usernameTextField.text)!
        }
        
    }
    
    


}
