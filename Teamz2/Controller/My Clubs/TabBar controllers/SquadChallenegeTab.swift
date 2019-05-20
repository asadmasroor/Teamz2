//
//  SquadChallenegeTab.swift
//  Teamz2
//
//  Created by Asad Masroor on 17/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

class SquadChallenegeTab: UITabBarController {
    // function that executes when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
        
        navigationItem.rightBarButtonItems = [homeButton]
    
    }
    
    //function that takes the user back to the main screen of the application.
    @objc func home(){
        navigationController?.popToRootViewController(animated: true)
    }

    

}
