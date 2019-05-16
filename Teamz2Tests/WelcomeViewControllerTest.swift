//
//  WelcomeViewController.swift
//  Teamz2Tests
//
//  Created by Asad Masroor on 16/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import XCTest
@testable import Teamz2

class WelcomeViewControllerTest: XCTestCase {
    
    var wvc = WelcomeViewController()

    override func setUp() {
        //siging up a new user
        wvc.username = "test1"
        
       
        
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignUp(){
        
        
     
       XCTAssertEqual(wvc.username, "test1")
        
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
