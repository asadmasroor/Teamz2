//
//  ClubRequestsViewCell.swift
//  Teamz2
//
//  Created by Asad Masroor on 06/05/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit

protocol clubRequestsDelegate: AnyObject {
    func acceptButtonPressed(cell: ClubRequestsViewCell)
    func declineButtonPressed(cell: ClubRequestsViewCell)
}

class ClubRequestsViewCell: UITableViewCell {

    weak var delegate: clubRequestsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var clubNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptButtonPressed(_ sender: Any) {
        delegate?.acceptButtonPressed(cell: self)
    }
    @IBAction func declineButtonPressed(_ sender: Any) {
        delegate?.declineButtonPressed(cell: self)
    }
}
