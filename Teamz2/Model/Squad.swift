//
//  Squad.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Squad: Object {
    
     @objc dynamic var name : String = ""
     var parentClub = LinkingObjects(fromType: Club.self, property: "squads")
     var fixtures = List<Fixture>()
    
    
    
}

