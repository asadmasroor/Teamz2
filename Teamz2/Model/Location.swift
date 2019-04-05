//
//  Location.swift
//  Teamz2
//
//  Created by Asad Masroor on 03/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Location : Object {
    @objc dynamic var latitude : Double = 0
    @objc dynamic var longitude : Double = 0
    @objc dynamic var timestamp : Date? = nil
    var parentRun = LinkingObjects(fromType: Run.self, property: "locations")
}
