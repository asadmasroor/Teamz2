//
//  FicxtureTableViewCell.swift
//  
//
//  Created by Asad Masroor on 05/03/2019.
//

import UIKit

protocol cellDelegateChallenge: AnyObject {
    func challengeButtonPressed(cell: FixtureTableViewCell)
}

class FixtureTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    weak var delegate: cellDelegateChallenge?
    
    @IBAction func challengeButtonPressed(_ sender: Any) {
         delegate?.challengeButtonPressed(cell: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFixture(fixture: Fixture){
        self.titleLabel.text = fixture.title
        self.addressLabel.text =  fixture.address
    }

}
