//
//  Club.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Club: Object {
    
    @objc dynamic var name : String = ""
    var members = List<User>()
    var admin : User?
    var squads = List<Squad>()
    

}
