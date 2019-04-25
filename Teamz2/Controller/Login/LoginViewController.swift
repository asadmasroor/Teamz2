//
//  LoginViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()
    var userLoggedIn : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  initialiseData()
        
        let user = realm.objects(User.self).filter("username == 'asadmasroor'")
        if user.count != 0 {
             userLoggedIn =  user[0]
        }
       

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! MainMenuViewController
            
            targetController.UserLoggedIn = userLoggedIn
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: ("signUpSegue"), sender: self)
    }
    
    
//   func initialiseData() {
//        
//        try! realm.write {
//            let User1 = User()
//            User1.name = "Asad"
//            User1.password = "password"
//            User1.username = "asadmasroor"
//            
//            let User2 = User()
//            User2.name = "Fahad Masroor"
//            User2.password = "password"
//            User2.username = "fahadmasroor"
//            
//            let User3 = User()
//            User3.name = "Eliza Masroor"
//            User3.password = "password"
//            User3.username = "elizamasroor"
//            
//            print(User1.name)
//            print(User3.name)
//            
//            
//            
//            let SSCC = Club()
//            SSCC.name = "SSCC"
//            print(SSCC.name)
//            
//            //        SSCC.admin = User1
//            SSCC.members.append(User1)
//            SSCC.members.append(User2)
//            SSCC.members.append(User3)
//            
//            
//            let MUFC = Club()
//            MUFC.name = "MUFC"
//            
//            SSCC.members.append(User1)
//            SSCC.members.append(User2)
//            SSCC.members.append(User3)
//            
//            print(SSCC.members[0].name)
//            
//            let firstXI = Squad()
//            firstXI.name = "First XI"
//            SSCC.squads.append(firstXI)
//            
//            let secondXI = Squad()
//            secondXI.name = "Second XI"
//            SSCC.squads.append(secondXI)
//            
//            let thirdXI = Squad()
//            thirdXI.name = "Third XI"
//            SSCC.squads.append(thirdXI)
//            
//            
//            let fixture1 = Fixture()
//            fixture1.title = "SSCC 1st XI vs NFC 1st XI"
//            fixture1.address = "Ostler's Lane"
//            
//            let availbility = Available()
//            availbility.user = User1
//            
//            let availbility2 = Available()
//            availbility2.user = User2
//            
//            let availbility3 = Available()
//            availbility3.user = User3
//            
//            fixture1.availablePlayers.append(availbility)
//            fixture1.availablePlayers.append(availbility2)
//            fixture1.availablePlayers.append(availbility3)
//            
//            
//            let availbility4 = Available()
//            availbility4.user = User1
//            
//            let availbility5 = Available()
//            availbility5.user = User2
//            
//            let availbility6 = Available()
//            availbility6.user = User3
//            
//            let fixture2 = Fixture()
//            fixture2.title = "SSCC 1st XI vs MUFC 1st XI"
//            fixture2.address = "Ostler's Lane"
//            fixture2.availablePlayers.append(availbility4)
//            fixture2.availablePlayers.append(availbility5)
//            fixture2.availablePlayers.append(availbility6)
//            
//            
//            //
//            //        let fixture3 = Fixture()
//            //        fixture3.title = "MCFC 1st XI vs SSCC 1st XI"
//            //        fixture3.address = "Old Trafford"
//            //        fixture3.availablePlayers.append(User1)
//            //        fixture3.availablePlayers.append(User2)
//            //        fixture3.availablePlayers.append(User3)
//            //
//            //
//            //
//            //
//            //
//            firstXI.fixtures.append(fixture1)
//            firstXI.fixtures.append(fixture2)
//            //        firstXI.fixtures.append(fixture3)
//            //
//            //        let fixture4 = Fixture()
//            //        fixture4.title = "SSCC 2nd XI vs LFC 1st XI"
//            //        fixture4.address = "Ostler's Lane"
//            //        fixture4.availablePlayers.append(User1)
//            //        fixture4.availablePlayers.append(User2)
//            //        fixture4.availablePlayers.append(User3)
//            //
//            //        let fixture5 = Fixture()
//            //        fixture5.title = "SSCC 2nd XI vs PSG 1st XI"
//            //        fixture5.address = "Ostler's Lane"
//            //        fixture5.availablePlayers.append(User1)
//            //        fixture5.availablePlayers.append(User2)
//            //        fixture5.availablePlayers.append(User3)
//            //
//            //        let fixture6 = Fixture()
//            //        fixture6.title = "MUFC 2nd XI vs SSCC 2nd XI"
//            //        fixture6.address = "Old Trafford"
//            //        fixture6.availablePlayers.append(User1)
//            //        fixture6.availablePlayers.append(User2)
//            //        fixture6.availablePlayers.append(User3)
//            //
//            //        secondXI.fixtures.append(fixture4)
//            //        secondXI.fixtures.append(fixture5)
//            
//            
//            let challenge1 =  Challenge()
//            challenge1.desc = "This is to test your stamina! Give it your best. Remember to pace yourself"
//            challenge1.miles = 20
//            challenge1.name = "Stamina Test"
//            challenge1.club = SSCC
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
//            let someDateTime = formatter.date(from: "2019/05/08 22:31")
//            
//            challenge1.expirydate = someDateTime!
//            
//            
//            //        let result1 = Result()
//            //        result1.user = User1
//            //        result1.timeTaken = "60"
//            //
//            //        let result2 = Result()
//            //        result2.user = User2
//            //        result2.timeTaken = "55"
//            //
//            //        let result3 = Result()
//            //        result3.user = User3
//            //        result3.timeTaken = "64"
//            
//            let challenge2 =  Challenge()
//            challenge2.desc = "This is to test sprinting speed"
//            challenge2.miles = 1
//            challenge2.name = "Sprinting Test"
//            challenge2.club = SSCC
//            challenge2.expirydate = someDateTime!
//            
//            challenge2.formatTime(date: challenge2.dateCreated)
//            
//            challenge2.formatTime(date: challenge2.expirydate)
//            challenge1.formatTime(date: challenge1.expirydate)
//            
//            
//            
//            
//            //        let result4 = Result()
//            //        result4.user = User1
//            //        result4.timeTaken = "6"
//            //
//            //        let result5 = Result()
//            //        result5.user = User2
//            //        result5.timeTaken = "3"
//            //
//            //        let result6 = Result()
//            //        result6.user = User3
//            //        result6.timeTaken = "10"
//            
//            
//            
//            //        challenge1.results.append(result1)
//            //        challenge1.results.append(result2)
//            //        challenge1.results.append(result3)
//            //
//            //        challenge2.results.append(result4)
//            //        challenge2.results.append(result5)
//            //        challenge2.results.append(result6)
//            //
//            
//            SSCC.challenges.append(challenge1)
//            SSCC.challenges.append(challenge2)
//            //        fixture3.challenges.append(challenge1)
//            //        fixture3.challenges.append(challenge2)
//            //        fixture4.challenges.append(challenge1)
//            //        fixture4.challenges.append(challenge2)
//            //        fixture5.challenges.append(challenge1)
//            //        fixture5.challenges.append(challenge2)
//            //        fixture6.challenges.append(challenge1)
//            //        fixture6 .challenges.append(challenge2)
//            
//            
//            
//            
//            User1.clubs.append(SSCC)
//            User2.clubs.append(SSCC)
//            
//            User1.joinedClubs.append(SSCC)
//            User2.joinedClubs.append(SSCC)
//            User3.joinedClubs.append(SSCC)
//            
//            User1.joinedClubs.append(MUFC)
//            User2.joinedClubs.append(MUFC)
//            User3.joinedClubs.append(MUFC)
//            
//            realm.add(User1)
//            realm.add(User2)
//            realm.add(User3)
//            
//            
//            
//            
//        }
//        
//        
//    }

}

