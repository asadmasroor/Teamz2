//
//  FixtureTests.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 17/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Teamz2

class FixtureTests: XCTestCase {

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
    
    func testMakeNewFixture() {
        
        // test to make sure no fixture exist
        let existingCount = testRealm.objects(Fixture.self).count
        XCTAssertEqual(existingCount, 0)
        
        //creating new fixture
        let fixture1 = Fixture()
        fixture1.title = "SSSC vs MUFC"
        fixture1.address = "Ostlers Lane"
        fixture1.time = Date()
        fixture1.time = Date()
        
        try! testRealm.write {
                testRealm.add(fixture1)
        }
        
        
        //Number of fixtures that exist should equal to 1
        XCTAssertEqual(testRealm.objects(Fixture.self).count, 1)
        print("newCount: \(testRealm.objects(Fixture.self).count)")
        
    }
    
    func testZDeleteFixture() {

        // test to make prove that only one fixture exists that was made in the previous test
        let existingCount = testRealm.objects(Fixture.self).count
        XCTAssertEqual(existingCount, 1)

        //retrieving fixture created in previous test
        let predicate = NSPredicate(format: "title = %@", "SSSC vs MUFC")
        let fixture1 = testRealm.objects(Fixture.self).filter(predicate)
        
        print("newCount: \(fixture1.count)")

        //deleteing fixture
        try! testRealm.write {
            testRealm.delete(fixture1)
        }

        //Number of fixtures that exist should equal to 0
        XCTAssertEqual(testRealm.objects(Fixture.self).count, 0)

    }
    
    
    

}
