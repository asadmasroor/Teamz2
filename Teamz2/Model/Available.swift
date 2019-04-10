//
//  Available.swift
//  Teamz2
//
//  Created by Asad Masroor on 10/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
import RealmSwift

class Available : Object {
    
    @objc dynamic var user : User?
    @objc dynamic var available : Bool = false
    
}
