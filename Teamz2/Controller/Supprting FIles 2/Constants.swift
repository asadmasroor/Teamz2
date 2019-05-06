//
//  Constants.swift
//  Teamz2
//
//  Created by Asad Masroor on 22/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import Foundation
struct Constants {

    static let MY_INSTANCE_ADDRESS = "teamz1.us1a.cloud.realm.io" // <- update this
    
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/Teamz")!
   
}


