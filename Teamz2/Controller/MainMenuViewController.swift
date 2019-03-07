//
//  MainMenuViewController.swift
//  Teamz2
//
//  Created by Asad Masroor on 07/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var UserLoggedIn = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func myClubButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "clubSegue", sender: self)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ClubViewController
        
        destinationVC.selectedUser = UserLoggedIn
    }
    
    
    
    
    func initialiseData() {
        let User1 = User()
        User1.name = "Asad Masroor"
        User1.password = "password"
        User1.username = "asadmasroor"
        
        let User2 = User()
        User2.name = "Fahad Masroor"
        User2.password = "password"
        User2.username = "fahadmasroor"
        
        let User3 = User()
        User3.name = "Eliza Masroor"
        User3.password = "password"
        User3.username = "elizamasroor"
        
        print(User1.name)
        print(User3.name)
        
        
        
        let SSCC = Club()
        SSCC.name = "SSCC"
        print(SSCC.name)
        
        //        SSCC.admin = User1
        SSCC.members.append(User1)
        SSCC.members.append(User2)
        SSCC.members.append(User3)
        
        print(SSCC.members[0].name)
        
        let firstXI = Squad()
        firstXI.name = "First XI"
        SSCC.squads.append(firstXI)
        
        
        let fixture1 = Fixture()
        fixture1.title = "SSCC 1st XI vs NFC 1st XI"
        fixture1.address = "Ostler's Lane"
        fixture1.availablePlayers.append(User1)
        fixture1.availablePlayers.append(User2)
        fixture1.availablePlayers.append(User3)
        
        let fixture2 = Fixture()
        fixture2.title = "SSCC 1st XI vs MUFC 1st XI"
        fixture2.address = "Ostler's Lane"
        fixture2.availablePlayers.append(User1)
        fixture2.availablePlayers.append(User2)
        fixture2.availablePlayers.append(User3)
        
        let fixture3 = Fixture()
        fixture3.title = "MCFC 1st XI vs SSCC 1st XI"
        fixture3.address = "Old Trafford"
        fixture3.availablePlayers.append(User1)
        fixture3.availablePlayers.append(User2)
        fixture3.availablePlayers.append(User3)
        
        
        
        
        
        firstXI.fixtures.append(fixture1)
        firstXI.fixtures.append(fixture2)
        firstXI.fixtures.append(fixture3)
        
        
        let challenge1 =  Challenge()
        challenge1.desc = "This is to test your stamina! Give it your best. Remember to pace yourself"
        challenge1.miles = 20
        challenge1.name = "Stamina Test"
        
        let result1 = Result()
        result1.user = User1
        result1.timeTaken = 60
        
        let result2 = Result()
        result2.user = User2
        result2.timeTaken = 55
        
        let result3 = Result()
        result3.user = User3
        result3.timeTaken = 64
        
        let challenge2 =  Challenge()
        challenge2.desc = "This is to test sprinting speed"
        challenge2.miles = 1
        challenge2.name = "Sprinting Test"
        
        let result4 = Result()
        result4.user = User1
        result4.timeTaken = 6
        
        let result5 = Result()
        result5.user = User2
        result5.timeTaken = 3
        
        let result6 = Result()
        result6.user = User3
        result6.timeTaken = 10
        
        
        
        challenge1.results.append(result1)
        challenge1.results.append(result2)
        challenge1.results.append(result3)
        
        challenge2.results.append(result4)
        challenge2.results.append(result5)
        challenge2.results.append(result6)
        
        
        fixture1.challenges.append(challenge1)
        fixture2.challenges.append(challenge2)
        
        User1.clubs.append(SSCC)
        
        UserLoggedIn = User1
    }

}
