//
//  SquadChallenegeTab.swift
//  Teamz2
//
//  Created by Asad Masroor on 17/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

class SquadChallenegeTab: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        let homeButton = UIBarButtonItem(image: UIImage(named:"home"), style: .plain, target: self, action: #selector(home))
        
        navigationItem.rightBarButtonItems = [homeButton]
        
       

        
        

        // Do any additional setup after loading the view.
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
