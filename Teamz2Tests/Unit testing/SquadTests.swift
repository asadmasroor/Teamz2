//
//  SquadTests.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 17/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Teamz2

class SquadTests: XCTestCase {

    var testRealm: Realm!
    
    override func setUp() {
        super.setUp()
        
        //Setting up an offline Realm for testing purposes
        testRealm = try! Realm(
            configuration: Realm.Configuration(inMemoryIdentifier: "test_Realm")
        )
        
    }
    
    override func tearDown() {
//        try! testRealm.write {
//            testRealm.deleteAll()
//        }
    }
    
    func testAddingNewSquad() {
       
        //There should be no sqaud
        let existingCount = testRealm.objects(Squad.self).count
        XCTAssertEqual(existingCount, 0)
        
        let squad = Squad()
        squad.name = "1st XI";

        
        try! testRealm.write {
            testRealm.add(squad)
        }
        
        //There should be only one squad in the database
        XCTAssertEqual(testRealm.objects(Squad.self).count, 1)
    }
    
    
    func testDeleteExistingSquad() {
        
        //There should be only 1 squad in the database which was created in testAddingNewSquad
        
        XCTAssertEqual(testRealm.objects(Squad.self).count, 1)
        
        //loading squad from database
        let squad = testRealm.objects(Squad.self)
        
        //deleting squad from database
        try! testRealm.write {
            testRealm.delete(squad[0])
        }
        
        //There should be no users in the database
        XCTAssertEqual(testRealm.objects(Squad.self).count, 0)
    }
    

    


}
