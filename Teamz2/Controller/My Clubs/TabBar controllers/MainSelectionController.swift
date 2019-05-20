//
//  MainSelectionController.swift
//  Teamz2
//
//  Created by Asad Masroor on 13/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

class MainSelectionController: UITabBarController {

    // function that executes when the view loads
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))

    }
    
    //function to go to main menu of the application
    @objc func home(){
        navigationController?.popToRootViewController(animated: true)
    }
    

}



