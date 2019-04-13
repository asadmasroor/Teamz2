//
//  Confirmation.swift
//  Teamz2
//
//  Created by Asad Masroor on 12/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Confirmation : Object {
    
    @objc dynamic var user : User?
    @objc dynamic var available : Bool = false
    var parentFixture = LinkingObjects(fromType: Fixture.self, property: "publishedSquad")
}

