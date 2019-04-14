//
//  User.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//



import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var username : String = ""
    @objc dynamic var password : String = ""
    @objc dynamic var name : String = ""
    var clubs = List<Club>()
    var joinedClubs = List<Club>()
    
    override static func primaryKey() -> String? {
        return "username"
    }
   
}

