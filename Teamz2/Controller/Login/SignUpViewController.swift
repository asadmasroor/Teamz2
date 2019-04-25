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
    let creds = SyncCredentials.usernamePassword(username: "\(usernameTextField.text!)", password: "\(passwordTextField.text!)", register: true)
        
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self!.performSegue(withIdentifier: "signedUpSegue", sender: self)
            } else if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
    }


}
