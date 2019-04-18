//
//  MainSelectionController.swift
//  Teamz2
//
//  Created by Asad Masroor on 13/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

class MainSelectionController: UITabBarController {
    
//    var userLoggedIn : User?
//    var selectedFixture : Fixture?

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))

    }
    
    @objc func home(){
        navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



