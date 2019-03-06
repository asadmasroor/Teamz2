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
//  @objc dynamic var homeTeam: Squad?
//  @objc dynamic var awayTeam =  Squad()
    @objc dynamic var address : String = ""
    var parentSquad = LinkingObjects(fromType: Squad.self, property: "fixtures")
    var challenges = List<Challenge>()
    var availablePlayers = List<User>()
    var selectedPlayers = List<User>()
    
}
