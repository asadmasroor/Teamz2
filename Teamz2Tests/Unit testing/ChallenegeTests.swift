//
//  ChallenegeTests.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 17/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2
import RealmSwift

class ChallenegeTests: XCTestCase {

    var testRealm: Realm!
    
    override func setUp() {
        super.setUp()
        
        //Setting up an offline Realm for testing purposes
        testRealm = try! Realm(
            configuration: Realm.Configuration(inMemoryIdentifier: "test_Realm")
        )
        
    }
    
    override func tearDown() {
     
    }
    
    func testAddingNewChallenge() {
        
        //There should be no challenege
        let existingCount = testRealm.objects(Challenge.self).count
        XCTAssertEqual(existingCount, 0)
        
        let challenge = Challenge()
        challenge.name = "Challenege 1";
        challenge.desc = "Test challenege"
        challenge.expirydate = Date()
        challenge.miles = 12
        
        
        try! testRealm.write {
            testRealm.add(challenge)
        }
        
        //There should be only one challenge in the database
        XCTAssertEqual(testRealm.objects(Challenge.self).count, 1)
    }
    
    
    func testZDeleteExistingChallenge() {
        
        //There should be only 1 challenge in the database which was created in testAddingNewChallenge
        
        XCTAssertEqual(testRealm.objects(Challenge.self).count, 1)
        
        //loading challenge from database
        let challenge = testRealm.objects(Challenge.self)
        
        //deleting challenge from database
        try! testRealm.write {
            testRealm.delete(challenge[0])
        }
        
        //There should be no users in the database
        XCTAssertEqual(testRealm.objects(Challenge.self).count, 0)
    }
    
    
    
}
