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
    @objc dynamic var approved : Bool = false
    var requests = List<User>()
    var squads = List<Squad>()
    var challenges = List<Challenge>()
    var parentUser = LinkingObjects(fromType: User.self, property: "clubs")
    var parentmMember = LinkingObjects(fromType: User.self, property: "joinedClubs")
    
    override static func primaryKey() -> String? {
        return "name"
    }

}
