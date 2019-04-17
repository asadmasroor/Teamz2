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
    @objc dynamic var dateCreated = Date()
    @objc dynamic var expirydate = Date()
    @objc dynamic var club : Club?
    var parentClub = LinkingObjects(fromType: Club.self, property: "challenges")
    var results = List<Result>()
    
    
    func formatTime(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.string(from: date)
        print(someDateTime)
        
    }
    
    
    
}
