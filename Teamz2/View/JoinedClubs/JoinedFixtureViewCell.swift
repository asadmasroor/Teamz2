//
//  JoinedFixtureViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 08/03/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol joinedFixtureDelegate: AnyObject {
    func challengeButtonPressed(cell: JoinedFixtureViewCell)
  
}
class JoinedFixtureViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: joinedFixtureDelegate?
    
    @IBAction func challengeButtonPressed(_ sender: Any) {
        delegate?.challengeButtonPressed(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setFixture(fixture: Fixture){
        self.addressLabel.text = fixture.address
        self.titleLabel.text = fixture.title
    }
}
