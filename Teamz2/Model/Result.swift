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
    
    @objc dynamic var timeTaken : Int = 0 ;
    @objc dynamic var user : User?
    var parentChallenge = LinkingObjects(fromType: Challenge.self, property: "results")
}
