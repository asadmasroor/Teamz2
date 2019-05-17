//
//  Fixture.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Fixture: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var date = Date()
    @objc dynamic var time = Date()
    var parentSquad = LinkingObjects(fromType: Squad.self, property: "fixtures")
    
    var availablePlayers = List<Available>()
    var publishedSquad = List<Confirmation>()
    
    
    
}
