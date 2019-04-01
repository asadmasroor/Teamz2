//
//  JoinedChallengeViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 24/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol joinedChallengeDelegate: AnyObject {
    func attemptChallenegeButtonPressed(cell: JoinedChallengeViewCell)
    
}
class JoinedChallengeViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: joinedChallengeDelegate?


    @IBAction func attemptChallenegeButtonPressed(_ sender: Any) {
        delegate?.attemptChallenegeButtonPressed(cell: self)
    }
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var milesLabel: UILabel!
    
    func setChallenge(challenge: Challenge){
        self.nameLabel.text = challenge.name
        self.descriptionLabel.text = challenge.desc
        self.milesLabel.text = String(challenge.miles)
    }
    
    
}
