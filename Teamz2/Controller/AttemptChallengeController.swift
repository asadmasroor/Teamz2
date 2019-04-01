//
//  AttemptChallengeController.swift
//  Teamz2
//
//  Created by Asad Masroor on 01/04/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import RealmSwift

class AttemptChallengeController: UIViewController {
    
    
    
    @IBOutlet weak var milesLabel: UILabel!
    
    var selectedChallenge : Challenge? {
        didSet {
            
            self.title = "\((selectedChallenge?.name)!)"

        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
