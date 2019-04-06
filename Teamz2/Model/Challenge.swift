//
//  Challenge.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Challenge: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var desc : String = ""
    @objc dynamic var miles : Int = 0
    var parentFixture = LinkingObjects(fromType: Fixture.self, property: "challenges")
    var results = List<Result>()
    
    
    
}
