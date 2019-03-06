//
//  ChallengeTableViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 05/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit



class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var milesLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChallenege(challenge: Challenge) {
        titleLabel.text = challenge.name
        descriptionTextField.text = challenge.desc
        milesLabel.text = "Miles: "+String(challenge.miles)
    }

}
