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
    
    
    
    
//    func loginUser(username: String) -> Bool {
//
//        var loggedIn = false
//
//        if let _ = SyncUser.current {
//            SyncUser.current?.logOut()
//        } else {
//            let creds = SyncCredentials.nickname("\(username)", isAdmin: true)
//
//            SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
//                if let _ = user {
//                    let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
//                    realm = try! Realm(configuration: config!)
//                    print("Logged In: Realm Query")
//                } else if let error = err {
//                    print("Cool")
//                }
//            })        }
//
//        return loggedIn
//
//    }
    
    func loginUser(username: String) {
        
        
        
            let creds = SyncCredentials.nickname("\(username)", isAdmin: true)
            
            SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                if let _ = user {
                   
                } else if let error = err {
                    print("Cool")
                }
            })
        
    }

    
  
  
    
    
    
    
    
    
    
}
