//
//  databaseTests.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 16/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2
import RealmSwift
class UserTests: XCTestCase {

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
    
    func test1AddingNewUser() {
        //There should be no users
        let existingCount = testRealm.objects(User.self).count
        XCTAssertEqual(existingCount, 0)
        
        let user1 = User()
        user1.username = "Test";
        
        try! testRealm.write {
            testRealm.add(user1)
        }
        
        //There should be only one user in the database
        XCTAssertEqual(testRealm.objects(User.self).count, 1)
    }
    
    func test2RetreiveExistingUser() {
        
        //There should be only 1 user in the database which was created in test1AddingNewUser()
        let existingCount = testRealm.objects(User.self).count
        XCTAssertEqual(existingCount, 1)
        
        //loading user from database
        let user1 = testRealm.objects(User.self)
        
        //There should be no users in the database
        XCTAssertEqual(user1[0].username,"Test")
    }

    
    func test3DeleteExistingUser() {
        
        //There should be only 1 user in the database which was created in testAddingNewUser()
        let existingCount = testRealm.objects(User.self).count
        XCTAssertEqual(existingCount, 1)
        
        //loading user from database
        let user1 = testRealm.objects(User.self)
        
        //deleting user from database
        try! testRealm.write {
            testRealm.delete(user1[0])
        }
        
        //There should be no users in the database
        XCTAssertEqual(testRealm.objects(User.self).count, 0)
    }
    
    // Function to automate adding test user for convience
    func addNewUser() {
       
        let user1 = User()
        user1.username = "Test";
        
        try! testRealm.write {
//            testRealm.deleteAll()
            testRealm.add(user1)
        }
    }
    

}
