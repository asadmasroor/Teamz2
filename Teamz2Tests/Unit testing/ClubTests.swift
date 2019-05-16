//
//  Club.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 17/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2
import RealmSwift


class ClubTests: XCTestCase {

    var testRealm: Realm!
    
    override func setUp() {
        
        testRealm = try! Realm(
            configuration: Realm.Configuration(inMemoryIdentifier: "test_Realm")
        )
        
        //Adding a new user for testing purposes
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeNewClub() {
        
        // test to make sure no clubs exist
        let existingCount = testRealm.objects(Club.self).count
        XCTAssertEqual(existingCount, 0)
        
        //creating new club
        let club1 = Club()
        club1.name = "SSSC"
        club1.approved = true
    
        try! testRealm.write {
            testRealm.add(club1)
        }
       
        //Number of clubs that exist should equal to 1
        XCTAssertEqual(testRealm.objects(Club.self).count, 1)
        
    }
    
    func testDeleteClub() {
        
        // test to make prove that only one club exists that was made in the previous test
        let existingCount = testRealm.objects(Club.self).count
        XCTAssertEqual(existingCount, 1)
        
        //retriving club created in previous test
        let predicate = NSPredicate(format: "name = %@", "SSCC")
        let club1 = testRealm.objects(Club.self).filter(predicate)
        
        //deleteing club
        try! testRealm.write {
            testRealm.delete(club1)
        }
        
        //Number of clubs that exist should equal to 0
        XCTAssertEqual(testRealm.objects(Club.self).count, 0)
        
    }
    
    
}
