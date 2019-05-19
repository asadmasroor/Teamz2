//
//  WelcomeViewController.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 16/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2
import RealmSwift
import Validation

class WelcomeViewControllerTest: XCTestCase {
    
    var wvc = WelcomeViewController()

    override func setUp() {
      
    }


    override func tearDown() {

    }
    
    func testValidation(){
        
        var v = Validation()
        v.minimumLength = 1
        v.maximumLength = 20
        
        //Valid username as username count is above 0 but below 20
        XCTAssertTrue(v.validateString("asad"));
        
        //inValid username as username count is equal to 0
        XCTAssertFalse(v.validateString(""));
        
        //inValid username as username count is above 20
        XCTAssertFalse(v.validateString("asadasadasadasadasadasadasad"));
        
    }
    
    func testSignUp(){

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
                
                // Assigning result from query
                usernameAfterSignUp = user1[0].username
                
                // Comparing result from query to orginal username that was set
                XCTAssertEqual(username, usernameAfterSignUp)
                
                //deleting user
                try! realm.write {
                    realm.delete(user1[0])
                }
                            
                
            } else if let error = err {
                print("This nickname already exists")
            }
        })


    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
