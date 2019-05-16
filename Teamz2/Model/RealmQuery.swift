//
//  RealmQuery.swift
//  Teamz2
//
//  Created by Asad Masroor on 16/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class RealmQuery {
    
    func loginUser(username: String) -> Bool {
        
        var loggedIn = false
    
        if let _ = SyncUser.current {
            loggedIn = true
        } else {
            let auth_url = URL(string: "teamz1.us1a.cloud.realm.io")!
            let creds = SyncCredentials.nickname("\(username)", isAdmin: true)
            
            SyncUser.logIn(with: creds, server: auth_url, onCompletion: { [weak self](user, err) in
                if let _ = user {
                    // User is logged in
                    loggedIn = true
                } else if let error = err {
                    fatalError(error.localizedDescription)
                }
            })
        }
        
        return loggedIn
       
    }
  
  
    
    
    
    
    
    
    
}
