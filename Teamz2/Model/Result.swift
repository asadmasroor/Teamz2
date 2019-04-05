//
//  Result.swift
//  Teamz2
//
//  Created by Asad Masroor on 04/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Result: Object {
    
//    @objc dynamic var timeTaken : String = "" 
    @objc dynamic var user : User?
    @objc dynamic var details : Run?
    var parentChallenge = LinkingObjects(fromType: Challenge.self, property: "results")
    
}
