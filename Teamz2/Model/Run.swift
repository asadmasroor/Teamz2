//
//  Run.swift
//  Teamz2
//
//  Created by Asad Masroor on 03/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Run : Object {
    @objc dynamic var distance : Double = 0
    @objc dynamic var duration : Int16 = 0
    @objc dynamic var timestamp : Date? = nil
    var locations = List<Location>()
}
