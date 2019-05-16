//
//  MainMenuViewControllerTest.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 16/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2
import RealmSwift
class MainMenuViewControllerTest: XCTestCase {
    
    let mmvc = MainMenuViewController()

    override func setUp() {
        
        let username = "testUser"
        var usernameAfterSignUp = ""
        let creds = SyncCredentials.nickname(username, isAdmin: true)
        
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                
                let config = SyncUser.current?.configuration()
                let realm = try! Realm(configuration: config!)
                
                let user = User()
                user.owner =  SyncUser.current!.identity!
                user.username = username
                
                //adding user to database
                try! realm.write {
                    realm.add(user)
                }
                
                let user1 = realm.objects(User.self).filter("username = %@", username)
                
                
                
            } else if let error = err {
                print("This nickname already exists")
            }
        })
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
